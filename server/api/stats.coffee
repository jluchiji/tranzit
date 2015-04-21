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
  stats  = require('../models/stats.js')(db)

  # Object where we will attach our functions
  self = { }

  # Get stats
  self.get = ->
    return (req, res) ->

      # Launch conveyor
      (conveyor = new Conveyor req, res)

        # Get statistics
        .then
          output: 'stats',
          stats.get

        # Report success
        .then conveyor.success
        .catch conveyor.error
        .done()


  return self
