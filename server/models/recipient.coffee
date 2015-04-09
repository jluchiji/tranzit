# --------------------------------------------------------------------------- #
#                                                                             #
# Tranzit Server                                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Tranzit Development Team                                   #
#                                                                             #
# --------------------------------------------------------------------------- #

# This is the data access file for recipient information.
# This is mostly a thin wrapper around SQL queries, however there is no secure
# information to worry about.

# Load npm packages we will be using
_       = require('underscore')  # Underscore.js: Big bunch of handy functions
uid     = require('shortid')     # shortid: Unique random string ID generator
squel   = require('squel')       # squel.js: SQL query builder
Promise = require('bluebird')    # bluebird: Fast Promise/A+ library

module.exports = (db) ->

  #Object where we'll attach all functions
  self = { }

  #Find recipient by their email
  self.findByEmail = (email) ->
    query = squel.select()
      .from('recipient')
      .where('email = ?', email)
    return db.get(query)

  #Find recipient by their ID
  self.findByID = (id) ->
    query = squel.select()
      .from('recipient')
      .where('id = ?', id)
    return db.get(query)

  self.emailsForRecipientsWithPendingPackages = ->
    query = squel.select()
      .from('recipient','r')
      .field('email')
      .join(squel.select().from('packages').where('released IS NULL'),
      'p', 'r.id = p.recipient')
    return db.query(query)

  #Create recipient
  self.create = (id, params) ->
    query = squel.insert()
      .into('recipient')
      .set('id', id)
      .set('firstName', params.firstName)
      .set('lastName', params.lastName)
      .set('address', params.address)
      .set('email', params.email)
    db.query(query)
      .then -> _.extend(params, id: id)

  #Updates a recipient's info
  self.update = (recipient, params) ->
    @config.output ?= 'recipient'

    query = squel.update()
      .table('recipient')
      .where('id = ?', recipient.id)

    if params.firstName
      query.set('firstName', params.firstName)
    if params.lastName
      query.set('lastName', params.lastName)
    if params.email
      query.set('email', params.email)
    if params.address
      query.set('address', params.address)

    db.query(query)
      .then ->
        if params.firstName
          recipient.firstName = params.firstName
        if params.lastName
          recipient.lastName = params.lastName
        if params.email
          recipient.email = params.email
        if params.address
          recipient.address = params.address
        return recipient

  return self
