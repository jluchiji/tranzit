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

# Load npm packages we will be using
_       = require('underscore')  # Underscore.js: Big bunch of handy functions
uid     = require('shortid')     # shortid: Unique random string ID generator
squel   = require('squel')       # squel.js: SQL query builder
Promise = require('bluebird')    # bluebird: Fast Promise/A+ library

# Load cryptographic tools we need in this file
crypto  = require('../lib/crypto.js')

# Export a high-order function, since we still need caller to supply db
module.exports = (db) ->

  # Object where we will attach all functions
  self = { }

  # Finds user entry by email address.
  # Returns a promise object that resolves with user record.
  self.findByEmail = (email) ->
    # Build the SQL query
    query = squel.select()
      .from('users')
      .where('email = ?', email)
    # Run it and return the promise
    return db.get(query)

  # Find user by ID
  self.findById = (id) ->
    query = squel.select()
      .from('users')
      .where('id = ?', id)
    db.get(query)

  # Create user
  self.create = (id, params, hash, auth) ->
    query = squel.insert()
      .into('users')
      .set('id', id)
      .set('firstName', params.firstName)
      .set('lastName', params.lastName)
      .set('email', params.email)
      .set('hash', hash)
      .set('auth', auth)
    db.query(query)
      .then -> _.extend(params, id: id, hash: hash, auth: auth)

  # Update user
  self.update = (user, params) ->
    @config.output ?= 'user'
    # Build the barebone query
    query = squel.update()
      .table('users')
      .where('id = ?', user.id)
    # Update display name if needed
    if params.firstName
      query = query.set('firstName', params.firstName)
    if params.lastName
      query = query.set('lastName', params.lastName)
    if params.hash
      query = query.set('hash', params.hash)
    if params.auth
      query = query.set('auth', params.auth)
    # Execute the query
    db.query(query)
      .then ->
        if params.firstName
          user.firstName = params.firstName
        if params.lastName
          user.lastName = params.lastName
        if params.hash
          user.hash = params.hash
          user.auth = params.auth
        return user

  # Sanitize user object to omit auth and hash
  self.sanitize = (user) ->
    return _.omit user, 'auth', 'hash'

  return self
