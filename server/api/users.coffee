# --------------------------------------------------------------------------- #
#                                                                             #
# Tranzit Server                                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Tranzit Development Team                                   #
#                                                                             #
# --------------------------------------------------------------------------- #

# This file contains the route handlers for /auth subroute.
# I will thoroughtly commenting this file so that you guys can get the idea
# of how Tranzit server works.

# Here we load npm packages we will need
uid      = require('shortid')                 # Unique ID generator

# Here we load utilities from lib directory
util     = require('../lib/util.js')          # Various utility methods
crypto   = require('../lib/crypto.js')        # Cryptogtaphy
Conveyor = require('../lib/conveyor.js')      # Promise-chaining

# Here we export a high-order function, since we need called to supply db
module.exports = (db) ->

  # Here we load APIs from data access module that are needed in this file
  auth   = require('../models/auth.js')(db)  # <-- Pass in the db object
  users  = require('../models/users.js')(db)

  # Object where we will attach our functions
  self = { }

  # Create a new user
  self.create = ->
    return (req, res) ->

      # Schema for required parameters
      schema =
        email: /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
        password: String
        firstName: String
        lastName: String

      # Promise chain start
      (conveyor = new Conveyor req, res, params: req.body)

        # Validate request body
        .then
          input: 'params',
          schema: schema,
          util.schema

        # Generate secret key
        .then
          output: 'auth',
          crypto.generateAuth

        # Hash password
        .then
          input: 'params.password',
          output: 'hash',
          crypto.bcryptHash

        # Generate unique ID
        .then
          output: 'uid',
          uid.generate

        # Create user record
        .then
          input: ['uid', 'params', 'hash', 'auth'],
          output: 'user',
          users.create

        # Create an auth token
        .then
          output: 'user.token',
          auth.createToken

        # Remove sensitive data
        .then
          input: 'user',
          users.sanitize

        # Send success response
        .then
          status: 201,
          conveyor.success

        # Handle errors
        .catch conveyor.error

        # Throw all unobserved exceptions
        .done()


  return self
