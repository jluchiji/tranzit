#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team

# This file contains route handlers for /recipients subroute

# Here we load utilities from lib directory
util     = require('../lib/util.js')          # Various utility methods
Conveyor = require('../lib/conveyor.js')      # Promise-chaining
uid      = require('shortid')                 # Unique ID generator

# Here we export a high-order function, since we need called to supply db
module.exports = (db) ->

  # Here we load APIs from data access module that are needed in this file
  recipients = require('../models/recipient.js')(db)

  # Object where we will attach our functions
  self = { }

  self.findByID = ->
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
          input: 'params.id',
          output: recipient,
          recipients.findByID

        # Make sure the recipient exists
        .then
          status: 404,
          message: 'Recipient not found.',
          util.exists

        # Send success or observe errors
        .then conveyor.success
        .catch conveyor.error
        .done()

  self.findByName = ->
    return (req, res) ->

      # Convert string boolean value
      if req.query.fuzzy is 'true'
        req.query.fuzzy = yes
      else if req.query.fuzzy is 'false'
        req.query.fuzzy = no
      
      # Schema for query params
      schema =
        name: String
        fuzzy: [Boolean, null]

      # Launch the conveyor
      (conveyor = new Conveyor req, res, params: req.query)

        # Validate request parameters
        .then
          input: 'params',
          schema: schema,
          util.schema

        # Perform search
        .then
          input: ['params.name', 'params.fuzzy'],
          output: 'matches',
          recipients.findByName

        # Make sure we are returning something
        .then
          message: 'No matching recipient(s) found.',
          util.exists

        # Return to client
        .then conveyor.success
        .catch conveyor.error
        .done()

  self.createRecipient = ->
    return (req, res) ->

      schema =
        id: String
        name: String
        email: /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
        zip: /^[0-9]+$/
        address: String

      # Promise chain start
      (conveyor = new Conveyor req, res, params: req.body)

        # Validate request body
        .then
          input: 'params',
          schema: schema,
          util.schema

        .then
          input: ['params.id', 'params'],
          output: 'recipient',
          recipients.create

        # Send success response
        .then
          status: 201,
          conveyor.success

        # Handle errors
        .catch conveyor.error

        # Throw all unobserved exceptions
        .done()

  return self
