#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team

nodemailer = require 'nodemailer'
util = require 'util'

module.exports = (db) ->

  # Gain access to query to pull emails of recipients still waiting on a package
  recipients = require('../models/recipient.js')(db)

  self = { }

  smtpTransport = nodemailer.createTransport('SMTP',
  service: 'Gmail'
  auth:
    user: 'server.tranzit@gmail.com'
    pass: 'dev@tranzit')

# function for sending out emails
  self.sendEmails = ->
    
    emails = recipients.emailsForRecipientsWithPendingPackages()

    emails.then (data) ->
      emailList = emails.toString
      console.log emailList

    mailOptions =
      from: 'Tranzit Server <server.tranzit@gmail.com>'
      to: 'aottinge@purdue.edu'
      subject: 'Package Pickup'
      html: '<b>Your package(s) is/are ready for pickup.</b>'
    smtpTransport.sendMail mailOptions, (error, response) ->
      if error
        console.log error

  return self
