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

  self.find = (params) ->
    query = squel.select()
      .from('packages')

    if params.recipient
      query = query.where('recipient = ?', params.recipient)

    return db.all(query)

  #Finds a package by tracking number
  self.findByTrackingNumber = (trackingNumber) ->
    query = squel.select()
      .from('packages')
      .where('tracking = ?', trackingNumber)
    return db.get(query)

  #Finds packages belonging to a user
  self.findByUserID = (userID) ->
    query = squel.select()
      .from('packages')
      .where('user = ?', userID)
    return db.all(query)

  #Finds packages by received date
  self.findByReceivedDate = (receivedDate) ->
    query = squel.select()
      .from('packages')
      .where('received = ?', receivedDate)
    return db.all(query)

    #Finds packages by its location
    self.findByLocation = (location) ->
      query = squel.select()
        .from('packages')
        .where('location = ?', location)
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
      .set('released = ?', released)
    db.query(query)
      .then ->
        packageObject.released = released
        return packageObject

  #Deletes a package
  self.delete = (packageID) ->
    query = squel.delete()
      .from('packages')
      .where('id = ?', packageID)
    return db.query(query)

  return self
