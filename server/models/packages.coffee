# --------------------------------------------------------------------------- #
#                                                                             #
# Tranzit Server                                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Tranzit Development Team                                   #
#                                                                             #
# --------------------------------------------------------------------------- #

# This is the data access file for package information.
# This is mostly a thin wrapper around SQL queries, however there is no secure
# information to worry about.

# Load npm packages we will be using
_       = require('underscore')  # Underscore.js: Big bunch of handy functions
uid     = require('shortid')     # shortid: Unique random string ID generator
squel   = require('squel')       # squel.js: SQL query builder
moment  = require('moment')      # moment.js: time handling library
Promise = require('bluebird')    # bluebird: Fast Promise/A+ library

module.exports = (db) ->

  #Object where we'll attach all functions
  self = { }

  # Query Parameters:
  # user - userID
  # recipient - recipientID
  # released - true | false

  self.find = (params) ->
    query = squel.select()
      .from('packages')
      .field('packages.*')
      .field('recipients.name', 'recipientName')
      .field('recipients.address', 'recipientAddress')
      .left_join('recipients', null, 'recipients.id = packages.recipient')
      .order('received', no)

    if params.recipient
      query = query.where('recipient = ?', params.recipient)

    if params.tracking
      query = query.where('tracking = ?', params.tracking)

    if params.user
      query = query.where('user = ?', params.user)

    if !_.isNull(params.released) and !_.isUndefined(params.released)
      if params.released
        query = query.where('released IS NOT NULL')
      else
        query = query.where('released IS NULL')

    if params.limit
      query = query.limit(params.limit)

    return db.all(query)

  #Creates a new package object
  self.create = (id, params, user) ->
    now = moment().unix()

    query = squel.insert()
      .into('packages')
      .set('id', id)
      .set('received', now)
      .set('tracking', params.tracking)
      .set('recipient', params.recipient)
      .set('user', user.id)
    db.query(query)
      .then -> _.extend(params, id: id, user: user.id)

  #Updates a package object
  self.update = (packageObject, released) ->
    @config.output ?= 'package'

    query = squel.update()
      .table('packages')
      .where('id = ?', packageObject.id)
      .set('released', released)
    db.query(query)
      .then ->
        packageObject.released = released
        return packageObject

  self.release = (recipient) ->
    query = squel.update()
      .table('packages')
      .set('released', moment().unix())
      .where('recipient = ?', recipient)
    console.log query.toString()
    db.query(query).then -> yes

  #Deletes a package
  self.delete = (packageID) ->
    query = squel.delete()
      .from('packages')
      .where('id = ?', packageID)
    return db.query(query)

  return self
