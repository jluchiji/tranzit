# --------------------------------------------------------------------------- #
#                                                                             #
# Tranzit Server                                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Tranzit Development Team                                   #
#                                                                             #
# --------------------------------------------------------------------------- #

# This is the main server file.
# Let's try to keep this file to bare minimum and put code into
# small, atomic modules for easier testing (if needed).

fs      = require 'fs'                # Node.FS: file system access
path    = require 'path'              # Node.Path: url and file path urilities
chalk   = require 'chalk'             # Chalk: color CLI output
winston = require 'winston'           # Winston: server log

express = require 'express'           # Express: express.js namespace
module.exports = app = express()

# Configure server log for CLI
winston.cli()

# If run from Gulp, force chalk color support
if process.env.NODE_ENV is 'gulp'
  chalk.enabled = yes
  chalk.supportsColor = yes
  winston.info 'Forcing chalk color support.'

# Create the database object
db       = require './data.js'
schema   = path.join __dirname, '/config/schema.sql'
db.init fs.readFileSync schema, 'utf8'

# Database initialization success
.then ->

  # Serve application files from the server root
  app.use '/', express.static __dirname + '/app'

  # Listen for incoming connections
  app.listen 3000, ->
    console.log 'Server listening on port 3000'
