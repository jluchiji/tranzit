#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team

# This file contains route handlers for /locations subroute

# Here we load utilities from lib directory
util     = require('../lib/util.js')          # Various utility methods
crypto   = require('../lib/crypto.js')        # Cryptogtaphy
Conveyor = require('../lib/conveyor.js')      # Promise-chaining
uid      = require('shortid')                 # Unique ID generator

# Here we export a high-order function, since we need called to supply db
module.exports = (db) ->

  # Here we load APIs from data access module that are needed in this file
  auth = require('../models/auth.js')(db)  # <-- Pass in the db object
  users = require('../models/users.js')(db)
  packages = require('../models/packages.js')(db)

  # Object where we will attach our functions
  self = { }

  self.createPackage = ->
    return (req, res) ->

    # Schema for required parameters
      schema =
        tracking: String
        received: String
        recipient: String

      # Promise chain start
      (conveyor = new Conveyor req, res, user: req.authUser, params: req.body)

      # Validate request parameters
        .then
          input: 'params',
          schema: schema,
          util.schema

      # Generate a unique id
        .then
          output: 'uid',
          uid.generate

      # Create a new package record
        .then
          input: ['uid', 'params', 'user'],
          output: 'package',
          packages.create

        .then
          status: 201,
          conveyor.success

        .catch conveyor.error

        # Throw all unobserved exceptions
        .done()