# --------------------------------------------------------------------------- #
#                                                                             #
# Tranzit Server                                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Tranzit Development Team                                   #
#                                                                             #
# --------------------------------------------------------------------------- #

path    = require('path')
express = require('express')

# Export a high-order function to allow main server file to pass in the db
module.exports = (db) ->

  # Load our middleware here
  authorize = require('./authorize.js')(db)

  # Load out api callbacks here
  auth  = require('./api/auth.js')(db)
  users = require('./api/users.js')(db)

  # Root router, whose mount path will be the Tranzit's root URL
  root = express.Router()

  # API router, which handles all API calls
  root.use '/api', api = express.Router()

  # Token parser
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

  # Static content router, which serves the Tranzit web app
  root.use st = express.Router()
  st.use express.static path.join __dirname, 'app'

  # Return root router for mounting
  return root
