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

  # Update a user's info
  self.update = ->
    return (req, res) ->
      # Schema for required parameters
      schema =
        firstName: [String, null]
        lastName: [String, null]
        password: [String, null]
        currentPassword: [String, null]

      # Start the Conveyor
      (conveyor = new Conveyor req, res, user: req.authUser, params: req.body)

        # Validata request parameters
        .then
          input: 'params',
          schema: schema,
          util.schema

      # Here, we branch the conveyor into two paths:
      #  - If credential update requested, then require old password
      #  - If no credentials update requested, proceed
      # If a secure auth token is provided, then no need to check current password

      # If password is being updated...
      if req.body.password

        # Re-authenticate if user supplied a general token
        if not req.authToken.isSecure
          conveyor
            .then
              input: 'params.currentPassword',
              status: 401,
              message: 'Authorization denied.',
              util.exists
            .then
              input: ['user', 'params.currentPassword'],
              auth.authenticate

        # Generate new secret key and hash the password
        conveyor
          .then
            output: 'params.auth',
            crypto.generateAuth
          .then
            input: 'params.password',
            output: 'params.hash',
            crypto.bcryptHash

      # Continue the pipeline
      conveyor

        # Update db records
        .then
          input: ['user', 'params'],
          output: 'user'
          users.update

      if req.body.password

        conveyor
          # Create an auth token
          .then
            output: 'user.token',
            auth.createToken
          # Remove sensitive data
          .then
            input: 'user',
            users.sanitize

      conveyor
        # Send success or observe errors
        .then users.sanitize
        .then conveyor.success
        .catch conveyor.error
        .done()

  # Find user (by email)
  self.find = ->
    return (req, res) ->
      # Schema for required parameters
      schema =
        email: /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/

      # Start the Conveyor
      (conveyor = new Conveyor req, res, params: req.params)

        # Validate request parameters
        .then
          input: 'params',
          schema: schema,
          util.schema

        # Find user by email
        .then
          input: 'params.email',
          output: 'user',
          users.findByEmail

        # Make sure the user exists
        .then
          status: 404,
          message: 'User not found.',
          util.exists

        # Send success or observe errors
        .then users.sanitize
        .then conveyor.success
        .catch conveyor.error
        .done()

  return self
