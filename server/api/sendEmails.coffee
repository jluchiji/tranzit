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
  self.sendEmails = (email = '') ->
   
    # Handles sending emails to all recipients with
    # pending packages
    if !email
      emails = recipients.emailsForRecipientsWithPendingPackages()

    # The idea below is to send an email to every email
    # returned in the query above.  The issue is that
    # I don't know how to extract each email from the
    # returned query.  Below x should be each email
    # in the email list if emails was simply a list
    # of emails as strings.

      for x of emails
        mailOptions =
          from: 'Tranzit Server <server.tranzit@gmail.com>'
          to: x
          subject: 'Package Pickup'
          html: '<b>Your package(s) is/are ready for pickup.</b>'

        smtpTransport.sendMail mailOptions, (error, response) ->
          if error
            console.log error
    # Handles the simple case of sending an email
    # when a new package is entered into the system
    else
      mailOptions =
        from: 'Tranzit Server <server.tranzit@gmail.com>'
        to: email
        subject: 'Package Pickup'
        html: '<b>Your package(s) is/are ready for pickup.</b>'

      smtpTransport.sendMail mailOptions, (error, response) ->
        if error
          console.log error

  return self
