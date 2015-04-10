# --------------------------------------------------------------------------- #
#                                                                             #
# Tranzit Server                                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Tranzit Development Team                                   #
#                                                                             #
# --------------------------------------------------------------------------- #

# This is the data access file for location information.
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

  #Finds a location by its address
  self.findByAddress = (address) ->
    query = squel.select()
      .from('location')
      .where('address = ?', address)
    return db.get(query)

  #Finds a location by its name
  self.findByName = (name) ->
    query = squel.select()
      .from('location')
      .where('name = ?', name)
    return db.get(query)

  #Finds a location by its id
  self.findByID = (locationID) ->
    query = squel.select()
      .from('location')
      .where('id = ?', locationID)
    return db.get(query)

  #Creates a new location object
  self.create = (id, params) ->
    query = squel.insert()
      .into('location')
      .set('id', id)
      .set('name', params.name)
      .set('address', params.address)
    db.query(query)
      .then -> _.extend(params, id: id)

  #Updates a location object
  self.update = (locationObject, name) ->
    @config.output ?= 'location'

    query = squel.update()
      .table('location')
      .where('id = ?', locationObject.id)
      .set('name = ?', name)
    db.qurey(query)
      .then ->
        locationObject.name = name
        return locationObject

  return self
