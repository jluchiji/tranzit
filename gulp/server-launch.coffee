# --------------------------------------------------------------------------- #
# tranzit-server build script.                                                #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Michael Schloss                                            #
# See LICENSE.md for terms of distribution.                                   #
# --------------------------------------------------------------------------- #

module.exports = (gulp, config) ->

  # This task launches an instance of the built application for viewing in a
  #   brower
  gulp.task 'server:launch', ['server:build'], ->

    path = require 'path'
    express = require 'gulp-express'

    express.run file: path.join(config.paths.dest, '/server.js'), env: 'gulp'
