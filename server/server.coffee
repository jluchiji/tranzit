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
nodemailer = require 'nodemailer'
schedule = require 'node-schedule'

express = require 'express'
module.exports = app = express()

smtpTransport = nodemailer.createTransport('SMTP',
  service: 'Gmail'
  auth:
    user: 'server.tranzit@gmail.com'
    pass: 'dev@tranzit')

# function for sending out emails
sendEmails = ->
  mailOptions =
    from: 'Tranzit Server <server.tranzit@gmail.com>'
    to: 'aottinge@purdue.edu, rosenbrea@purdue.edu, mschlos@purdue.edu, jluchiji@purdue.edu'
    subject: 'Package Pickup'
    html: '<b>Come pick up your package(s) you lazy asshole</b>'
  smtpTransport.sendMail mailOptions, (error, response) ->
    if error
      console.log error

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

  # send email to those who need to pick up a package at server startup
  sendEmails()
  # send email everyday to people who have a package pending their pickup
  schedule.scheduleJob({
    hour: 9
    minute: 0
  }, sendEmails())
 
  # begin listening for connections
  app.listen 3000, ->
    console.log 'Server listening on port 3000'
