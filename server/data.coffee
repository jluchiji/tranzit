# --------------------------------------------------------------------------- #
#                                                                             #
# Tranzit Server                                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Tranzit Development Team                                   #
#                                                                             #
# --------------------------------------------------------------------------- #

# This file handles global database-related stuff.
# Note that this file is only executed ONCE on server start.

_       = require 'underscore'        # Underscore.js: a utility library
squel   = require 'squel'             # Squel.js: SQL Query Builder
mysql   = require 'mysql-promise'     # mysql-promise: MySQL with promises
promise = require 'bluebird'          # bluebird: Fast Promise/A+ library
winston = require 'winston'           # Winston: Server logging

# Debug logger, suppressed for production
debug   = require('debug')('tranzit:data')

# Create database adapter
dbconf  = require('./config.js')('db.yml')
db      = require('mysql-promise')()

# Configure database using config file
db.configure dbconf

# Monkey-patch database to support Squel.js queries out of the box
# This way you can directly pass a Squel.js query object to db.query()
# without the need for manually calling query.toParam()
db.$query = db.query
db.query  = (query) ->
  if query instanceof squel.cls.QueryBuilder
    query = query.toParam()
    return @$query query.text, query.values
  else
    return @$query.apply @, arguments

# Monkey-patch in a few handy shortcu functions for DB

# Gets the first row matching the query
db.get = ->
  @query.apply(@, arguments).then (result) -> return result[0][0]


# Initializes the database if it is empty.
# Returns a promise that resolves with the db object.
db.init   = (script) ->
  query = squel.select()
    .from  'information_schema.columns'
    .field 'COUNT(DISTINCT(table_name))', 'table_count'
    .where 'table_schema = ?', dbconf.database
  db.query query

    # Upon successful query, if database is empty, execute init script
    .then (result) ->
      if result[0][0].table_count is 0
        winston.info 'Empty database...executing init script.'

        # node-mysql does not support multiple statement queries, so we
        # will have to split the config file ourselves...
        # Regex is aaweeesooome ヾ(´□｀)ノ
        matches = script.match /(?:^|\n)\S([^;]*;)/g

        # Map statements to queries and wait for all of them to complete
        return promise.all _.map matches, (i) -> db.query(i)
      else
        return undefined

    .catch (error) ->
      winston.error "Database connection failed. Reason: #{error.message}"
      process.exit 1

# Export database adapter
module.exports = db
