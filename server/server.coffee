#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team

# Main Server File

# Sourcemap support
require('source-map-support').install()

fs = require 'fs'
path = require 'path'
chalk = require 'chalk'      # provides colored output
winston = require 'winston'  # server log

express = require 'express'
module.exports = app = express()

# Set up server log for CLI
winston.cli()

# Use chalk color support when running from Gulp
if process.env.NODE_ENV is 'gulp'
  chalk.enabled = yes
  chalk.supportsColor = yes
  winston.info 'Force use of chalk color support'

# Set up database object
db = require './data.js'
schema = path.join __dirname, '/config/schema.sql'
db.init fs.readFileSync schema, 'utf8'

# db initialization successful
.then ->
  # parse JSON requests
  app.use require('body-parser').json()
  # mount root router, defined in routes.coffee
  app.use require('./routes.js')(db)
  # begin listening for connections
  app.listen 3000, ->
    console.log 'Server listening on port 3000'
