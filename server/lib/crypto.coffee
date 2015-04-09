#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team

_ = require 'underscore'
bcrypt = require 'bcrypt-nodejs'
crypto = require 'crypto'
moment = require 'moment'
Promise = require 'bluebird'
msgpack = require 'msgpack'
urlsafe = require 'urlsafe-base64'
winston = require 'winston'
config = require('../config.js')('server.yml')
self = module.exports

# Generate salt for bcrypt password hashing
self.genSalt = Promise.promisify bcrypt.genSalt
# Hash data with bcrypt
self.hash = Promise.promisify bcrypt.hash

# Compare already existing hash with hashed data
self.compare = (plain, hash) ->
  return new Promise (resolve, reject) ->
    bcrypt.compare plain, hash, (error, result) ->
      if error then reject(error)
      else resolve(result)

# Generate bcrypt hash of password
self.bcryptHash = (password) ->
  return new Promise (resolve, reject) ->
    bcrypt.genSalt config.security.saltRounds, (error, result) ->
      if error then reject(error)
      else bcrypt.hash password, result, null, (error, result) ->
        if error then reject(error)
        else resolve(result)

# Creates crypto, a strong array of random bytes encoded in base64
self.generateAuth = ->
  Promise.promisify(crypto.randomBytes)(config.security.authSize)
    .then (buf) -> buf.toString('base64')

# Creates keyed hash of data in base64 format
self.hmacDigest = (data, key, short=yes, algorithm='SHA256') ->
  return new Promise (resolve) ->
    hash = crypto.createHmac(algorithm, key).update(data).digest()
    # When short = yes, slice away right half of hash output
    if short then hash = hash.slice(0, hash.length / 2)
    resolve hash.toString('base64')

# Creates authorization token for the passed in user
# user parameter is the user object returned by the database module
# If secure is true, the function revokes all the previous tokens
self.createToken = (user, secure=no) ->
  time = Math.floor(new Date().getTime() / 1000)
  meta = [secure, user.id, time]
  payload = msgpack.pack(meta)
  self.hmacDigest(payload, user.auth)
    .then (hash) ->
      meta.push(hash)
      urlsafe.encode(msgpack.pack meta)
