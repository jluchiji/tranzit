# --------------------------------------------------------------------------- #
#                                                                             #
# Tranzit Server                                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Tranzit Development Team                                   #
#                                                                             #
# --------------------------------------------------------------------------- #

# This is the data access file for user information.
# This is mostly a thin wrapper around SQL queries, so data returned by this
# module may contain sensitive information like secret keys. This information
# has to be stripped before sent to client by server routing module.

# Load cryptographic tools we need in this file
crypto  = require('../lib/crypto.js')

module.exports = (db) ->

  self = { }

  # Verifies user's password against hash
  self.authenticate = (user, password) ->
    crypto.compare(password, user.hash)
      .then (result) =>
        if not result
          @conveyor.panic('Credentials rejected.', 401)

  # Creates an auth token for the user
  self.createToken = (user) ->
    crypto.createToken(user, @config.isSecure ? no)

  return self
