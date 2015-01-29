# --------------------------------------------------------------------------- #
# wyvernzora.ninja build script.                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Denis Luchkin-Zhou                                         #
# See LICENSE.md for terms of distribution.                                   #
# --------------------------------------------------------------------------- #
module.exports = (gulp, config) ->

  gulp.task 'client:html', ->

    gulp.src ['app/**.html'], base: './'
      .pipe gulp.dest config.paths.dest

  gulp.task 'client:jade', ->

    _     = require 'underscore'
    path  = require 'path'
    jade  = require 'gulp-jade'

    # Backup the old scripts array
    config._scripts ?= config.scripts
    # Inject bower files depending on target
    if not config.concat
      bower = _.map config.bower.scripts, (i) ->
        path.join 'lib', i
      config.scripts = bower.concat config._scripts
    else
      config.scripts = ['lib/bower.js'].concat config._scripts

    # Process markup
    gulp.src ['app/**/*.jade', '!**/*.part.jade'], base: './'
      .pipe jade locals: config
      .pipe gulp.dest config.paths.dest
