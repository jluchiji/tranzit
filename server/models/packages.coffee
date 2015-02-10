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
Promise = require('bluebird')    # bluebird: Fast Promise/A+ library

module.exports = (db) ->

  #Object where we'll attach all functions
  self = { }

  #Finds a package by tracking number
  self.findByTrackingNumber = (trackingNumber) ->
    query = squel.select()
      .from('package')
      .where('tracking = ?', trackingNumber)
    return db.get(query)

  #Finds packages belonging to a user
  self.findByUserID = (userID) ->
    query = squel.select()
      .from('package')
      .where('user = ?', userID)
    return db.get(query)

  #Finds packages by received date
  self.findByReceivedDate = (receivedDate) ->
    query = squel.select()
      .from('package')
      .where('received = ?', receivedDate)
    return db.get(query)

  #Creates a new package object
  self.create = (id, params, user) ->
    query = squel.insert()
      .into('package')
      .set('id', id)
      .set('tracking', params.tracking)
      .set('received', params.received)
      .set('recipient', params.recipient)
      .set('user', user)
    db.query(query)
      .then -> _.extend(params, id: id, user: user)

  #Updates a package object
  self.update = (packageObject, released) ->
    @config.output ?= 'package'

    query = squel.update()
      .table('package')
      .where('id = ?', packageObject.id)
      .set('released = ?', released)
    db.qurey(query)
      .then ->
        packageObject.released = released
        return packageObject

  return self
