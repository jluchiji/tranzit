# --------------------------------------------------------------------------- #
# wyvernzora.ninja build script.                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Denis Luchkin-Zhou                                         #
# See LICENSE.md for terms of distribution.                                   #
# --------------------------------------------------------------------------- #
module.exports = (gulp, config) ->

  gulp.task 'bower:scripts', ->

    _          = require 'underscore'
    path       = require 'path'
    gulpif     = require 'gulp-if'
    uglify     = require 'gulp-uglify'
    concat     = require 'gulp-concat'
    sourcemap  = require 'gulp-sourcemaps'

    # Map bower paths to actual bower paths
    paths = _.map config.bower.scripts, (i) ->
      path.join 'bower_components', i

    # Process bower scripts
    gulp.src paths, base: './bower_components'

      # Concat if needed
      .pipe sourcemap.init()
      .pipe gulpif config.concat, concat 'bower.js'
      .pipe gulpif config.minify, uglify()
      .pipe gulpif config.sourcemaps, sourcemap.write './'
      .pipe gulp.dest path.join config.paths.dest, 'app/lib'
