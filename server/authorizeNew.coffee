#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team

# Middleware funciton for auth checks

_ = require 'underscore'
squel = require 'squel'
winston = require 'winston'
msgpack = require 'msgpack'
urlsafe = require 'urlsafe-base64'
moment = require 'moment'

crypto = require './lib/crypto.js'
util = require './lib/util.js'
Conveyor = './lib/conveyor.js' 
config = require('./config.js')('server.yml')

module.exports = (db) ->
  # internal will find the user at the specified location
  self = _internal: {}

  self.tokenParser = ->
    return(req, res, next) ->
      (conveyor = new Conveyor req, res, token: req.headers['x-tranzit-auth'])
        .then
          input: 'token',
          (token) ->
            if not token then @conveyor.panic('Missing auth token',400,ignore:yes)
            if not urlsafe.validate(token)
              @conveyor.panic('Malformed auth token:' + token, 400)
            return token
          .then (token) ->
            meta = msgpack.unpack urlsafe.decode token
            if not _.isArray(meta)
              @conveyor.panic('Malformed auth token:' + token, 400)
            else
              return {
                isSecure: meta[0]
                userId: meta[1]
                createdAt: meta[2]
                _signature: meta[3]
                _payload: msgpack.pack(meta.slice(0,-1))
              }
            .then (token) ->
              req.authToken = token
              next()
            .catch (error) ->
              if not error.details?.ignore
                winston.warn error.toString()
              req.authToken = null
              next()
            .done()

  self.user = (type = 'default') ->
    return (req, res, next) ->
      conveyor = new Conveyor req, res, token: req.authToken
      conveyor
        .then
          input: 'token',
          (token) ->
            if token is undefined
              @conveyor.panic('undefined token: did you load tokenParser?')
            if token is null
              @conveyor.panic('Malformed auth token', 400)
            if type isnt 'any'
              if type is 'default' and token.isSecure
                @conveyor.panic('Bad auth token type: non-secure token required', 401)
              if type is 'secure' and not token.isSecure
                @conveyor.panic('Bad auth token type: secure token required', 401)
            return token
          .then
            output: 'user',
            (token) ->
              db.get squel.select().from('users').where('id = ?', token.userId)
          .then
            status: 404,
            message: 'User not found',
            util.exists
          .then
            input: ['token._payload', 'user.auth'],
            output: 'hmac'
            crypto.hmacDigest
          .then
            input: ['token', 'hmac'],
            (token, hmac) ->
              if token._signature isnt hmac
                @conveyor.panic('Bad token signature', 401)
              ttl = if token.isSecure
                config.security.tokenTtl
              else
                config.security.secureTokenTtl
              time = moment().unix() - token.createdAt
              if time > ttl then @conveyor.panic('Auth token expired', 401)
              if req.params.userId and (token.userId isnt req.params.userId)
                @conveyor.panic('Token user ID does not match requested resource owner ID', 401)
          .then
            input: 'user',
            (user) ->
              req.authUser = user
              next()
          .catch
            status: 401,
            message: 'Authorization denied',
            conveyor.error
          .done()

  return self
