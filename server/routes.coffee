#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team

path = require 'path'
express = require 'express'

# Export function so that the main server can receive the db
module.exports = (db) ->
  # Middleware
  authorize = require('./authorize.js')(db)
  # api callbacks
  auth = require('./api/auth.js')(db)
  users = require('./api/users.js')(db)
  locations = require('./api/locations.js')(db)
  # Root router; mount path = Tranzit root URL
  root = express.Router()
  # API router; takes care of API calls
  root.use '/api', api = express.Router()
  # Parse tokens
  api.use '*', (req, res, next) ->
    res.setHeader('Content-Type', 'application/json')
    next()
  api.use '*', authorize.tokenParser()

  # /auth
  api.route '/auth'
    # POST /api/auth
    .post auth.create()
    # GET /api/auth
    .get authorize.user()
    .get auth.renew()
    # DELETE /api/auth
    .delete authorize.user()
    .delete auth.revoke()

  # /users
  api.route '/users'
    # POST /api/users
    .post users.create()
    # PUT /api/users
    .put authorize.user('any')
    .put users.update()
  api.route '/users/:email'
    # GET /api/users/:email
    .get users.find()

  # /locations
  api.route '/locations/:id/packages'
    # POST /api/locations
    .post authorize.user()
    .post locations.createPackage()

  # Static router for content, which works for the Tranzit web app
  root.use st = express.Router()
  st.use express.static path.join __dirname, 'app'

  return root