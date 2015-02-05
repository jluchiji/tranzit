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

  # Default error message in case of error
  errorMessage = status: 401, message: 'Authorization denied.'


  # Route handler for (POST /auth)
  # Note that from outside this file, it will be called like 'auth.create(...)'
  self.create = ->
    # We might need to reuse this handler, so we use a factory pattern here
    return (req, res) ->

      # This is schema for the request body, so that we make sure all
      # required information is all there and valid
      schema =
        email: /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
        password: String

      # Create a new conveyor (promise sequence), and make req.body available
      # to all promises in this chain
      # If any of the steps fail, the sequence is aborted and the client get
      # a corresponding error response.
      (conveyor = new Conveyor req, res, params: req.body)

        # Validate params against request body
        .then
          input: 'params',
          schema: schema,
          util.schema

        # Find a user by email
        .then
          input: 'params.email',
          output: 'user',
          users.findByEmail

        # Make sure the user exists
        .then
          status: 404,
          message: 'User not found.',
          util.exists

        # Check user password
        .then
          input: ['user', 'params.password'],
          auth.authenticate

        # Create auth token
        .then
          input: 'user',
          output: 'user.token',
          auth.createToken

        # Remove sensitive information from the user object
        .then
          input: 'user',
          users.sanitize

        # Send response
        .then conveyor.success

        # In case if one of the steps failed... respond with an error
        # in this particular case, we want to replace ALL errors with 401
        # and not provide client information about what exactly failed.
        .catch errorMessage, conveyor.error

        # Make sure conveyor throws all exceptions that were not handled by
        # .catch(). Without this call, they may never be observed.
        .done()


  # Route handler for (GET /auth)
  self.renew = ->
    return (req, res) ->

      #Start the Conveyor
      (conveyor = new Conveyor req, res, user: req.authUser)

        # Create a new token for the user
        .then
          input: 'user',
          output: 'user.token',
          auth.createToken

        # Remove sensitive information from response
        .then
          input: 'user',
          users.sanitize

        # Send response, observe errors
        .then conveyor.success
        .catch errorMessage, conveyor.error
        .done()

  # Route handler for (DELETE /auth)
  self.revoke = ->
    return (req, res) ->

      #Start the Conveyor
      (conveyor = new Conveyor req, res, user: req.authUser)

        # Generate a new secret key
        .then
          output: 'params.auth',
          crypto.generateAuth

        # Update user to have the new secret key
        .then
          input: ['user', 'params'],
          users.update

        # Create a new auth token for the user
        .then
          input: 'user',
          output: 'user.token',
          auth.createToken

        # Remove sensitive information from response
        .then
          input: 'user',
          users.sanitize

        # Send success or observe errors
        .then conveyor.success
        .catch errorMessage, conveyor.error
        .done()


  return self
