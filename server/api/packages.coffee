#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team

# This file contains route handlers for /locations subroute, specifically package addition

# Here we load utilities from lib directory
util     = require('../lib/util.js')          # Various utility methods
Conveyor = require('../lib/conveyor.js')      # Promise-chaining
uid      = require('shortid')                 # Unique ID generator

# Here we export a high-order function, since we need called to supply db
module.exports = (db) ->

  # Here we load APIs from data access module that are needed in this file
  packages = require('../models/packages.js')(db)

  # Object where we will attach our functions
  self = { }

  self.find = ->
    return (req, res) ->
      schema =
        user: [String, null]
        tracking: [String, null]
        recipient: [String, null]

      (conveyor = new Conveyor req, res, user: req.authUser, params: req.query)

        .then
          input: 'params',
          schema: schema,
          util.schema

        .then
          input: 'params',
          output: 'packages',
          packages.find

        .then conveyor.success
        .catch conveyor.error
        .done()

  self.createPackage = ->
    return (req, res) ->

    # Schema for required parameters
      schema =
        tracking: String
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


  self.updatePackage = ->
    return (req, res) ->

    # Schema for required parameters
      schema =
        id: String
        timeStamp: Number

      # Promise chain start
      (conveyor = new Conveyor req, res, user: req.authUser, params: req.body)

      # Validate request parameters
        .then
          input: 'params',
          schema: schema,
          util.schema

        .then
          input: 'params.id',
          output: 'package',
          packages.findByUserID

        .then
          input: ['package', 'params.timeStamp'],
          packages.update

        # Send success or observe errors
        .then conveyor.success
        .catch conveyor.error
        .done()


  self.deletePackage = ->
    return (req, res) ->

    # Schema for required parameters
      schema =
        id: String

      # Promise chain start
      (conveyor = new Conveyor req, res, user: req.authUser, params: req.body)

      # Validate request parameters
        .then
          input: 'params',
          schema: schema,
          util.schema

        .then
          input: 'params.id'
          packages.delete

        # Send success or observe errors
        .then conveyor.success
        .catch conveyor.error
        .done()

  return self
