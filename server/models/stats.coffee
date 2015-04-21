# --------------------------------------------------------------------------- #
#                                                                             #
# Tranzit Server                                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Tranzit Development Team                                   #
#                                                                             #
# --------------------------------------------------------------------------- #

# This is the data access file for statistics.
# This is mostly a thin wrapper around SQL queries, so data returned by this
# module may contain sensitive information like secret keys. This information
# has to be stripped before sent to client by server routing module.

# Load npm packages we will be using
_       = require('underscore')  # Underscore.js: Big bunch of handy functions
uid     = require('shortid')     # shortid: Unique random string ID generator
squel   = require('squel')       # squel.js: SQL query builder
moment  = require('moment')      # moment.js: Time manipulation library
Promise = require('bluebird')    # bluebird: Fast Promise/A+ library

# Load cryptographic tools we need in this file
crypto  = require('../lib/crypto.js')

# Export a high-order function, since we still need caller to supply db
module.exports = (db) ->

  # Object where we will attach all functions
  self = { }

  # Gets the server statistics
  self.get = ->
    queries =
      # Get the total number of packages processed within last 24 hours
      last24: db.get(squel.select()
        .from('packages')
        .field('COUNT(*)', 'count')
        .where('received >= ?', moment().unix()))
      # Get the total number of unclaimed packages
      unclaimed: db.get(squel.select()
        .from('packages')
        .field('COUNT(*)', 'count')
        .where('released IS NULL'))
      # Get the number of packages with errors
      haveErrors: db.get(squel.select()
        .from('packages')
        .field('COUNT(*)', 'count')
        .where('status = ?', 1))

    return Promise.props(queries)

  return self
