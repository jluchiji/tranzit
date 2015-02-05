# --------------------------------------------------------------------------- #
#                                                                             #
# Tranzit Server                                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Tranzit Development Team                                   #
#                                                                             #
# --------------------------------------------------------------------------- #

# This file contains middleware functions for authorization checks.
_       = require('underscore')
squel   = require('squel')
winston = require('winston')
msgpack = require('msgpack')
urlsafe = require('urlsafe-base64')
moment  = require('moment')

# Load files in the /lib
crypto  = require('./lib/crypto.js')
util     = require('./lib/util.js')
Conveyor = require('./lib/conveyor.js')

# Load server configuration
config  = require('./config.js')('server.yml')

# Export a high-order function since we need called to supply db
module.exports = (db) ->

  # Object where we will attack functions
  self = _internal: { }

  # INTERNAL: Find user at the specified location


  # Token parser middleware. Parses auth token into req.authToken.
  self.tokenParser = ->
    return (req, res, next) ->
      # Use a Conveyor to handle to stuff
      (conveyor = new Conveyor req, res, token: req.headers['x-tranzit-auth'])
        # Check whether the token looks right
        .then
          input: 'token',
          (token) ->
            if not token then @conveyor.panic('Missing auth token', 400, ignore: yes)
            if not urlsafe.validate(token)
              @conveyor.panic('Malformed auth token:' + token, 400)
            return token
        # Unpack the token
        .then (token) ->
          meta = msgpack.unpack urlsafe.decode token
          # If meta is not array, auth token is invalid
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
        # Successfully parsed the token, proceed
        .then (token) ->
          req.authToken = token
          next()
        # Token is malformed or missing, print warning and go on
        .catch (error) ->
          if not error.details?.ignore
            winston.warn error.toString()
          req.authToken = null
          next()
        # Throw unhandled errors
        .done()


  # User authorization check
  self.user = (level = 'user', type = 'default') ->
    return (req, res, next) ->
      # Use a Conveyor to handle the stuff
      conveyor = new Conveyor req, res, token: req.authToken
      conveyor
        # Auth token sanity check
        .then
          input: 'token',
          (token) ->
            # Token is undefined only if tokenParser was not called for this endpoint
            if token is undefined
              @conveyor.panic('undefined token: did you load tokenParser?')
            # Token is null only if parsing failed
            if token is null
              @conveyor.panic('Malformed auth token.', 400)
            # Make sure token type matches what is needed
            if type isnt 'any'
              if type is 'default' and token.isSecure
                @conveyor.panic('Bad auth token type: non-secure token required.', 401)
              if type is 'secure' and not token.isSecure
                @conveyor.panic('Bad auth token type: secure token required.', 401)
            return token
        # Find the user by ID
        .then
          output: 'user',
          (token) ->
            db.get squel.select().from('users').where('id = ?', token.userId)
        # Check if user exists
        .then
          status: 404,
          message: 'User not found.',
          util.exists
        # Compute HMAC using user's auth code
        .then
          input: ['token._payload', 'user.auth'],
          output: 'hmac',
          crypto.hmacDigest
        # Verify token signature and TTL
        .then
          input: ['token', 'hmac'],
          (token, hmac) ->
            # Check if signatures match
            if token._signature isnt hmac
              @conveyor.panic('Bad token signature.', 401)
            # Check if token is expired
            ttl = if token.isSecure
              config.security.tokenTtl
            else
              config.security.secureTokenTtl
            time = moment().unix() - token.createdAt
            if time > ttl then @conveyor.panic('Auth token expired.', 401)
            # If params includes :userId, check if token belongs to the user
            if req.params.userId and (token.userId isnt req.params.userId)
              @conveyor.panic('Token user ID does not match requested resource owner ID.', 401)
        # No problems, proceed
        .then
          input: 'user',
          (user) ->
            req.authUser = user
            next()
        # Boss, we got a problem!
        .catch
          status: 401,
          message: 'Authorization denied.',
          conveyor.error
        .done()

  return self
