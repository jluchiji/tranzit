# --------------------------------------------------------------------------- #
# wyvernzora.ninja build script.                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Denis Luchkin-Zhou                                         #
# See LICENSE.md for terms of distribution.                                   #
# --------------------------------------------------------------------------- #
module.exports = (gulp, config) ->

  gulp.task 'client:scripts', ->

    path       = require 'path'
    lint       = require 'gulp-coffeelint'
    addsrc     = require 'gulp-add-src'
    gulpif     = require 'gulp-if'
    concat     = require 'gulp-concat'
    coffee     = require 'gulp-coffee'
    uglify     = require 'gulp-uglify'
    plumber    = require 'gulp-plumber'
    sourcemaps = require 'gulp-sourcemaps'
    ngAnnotate = require 'gulp-ng-annotate'

    gulp.src ['app/**/*.coffee'], base: './app'

      # Prevent crashes
      .pipe plumber()

      # Lint
      .pipe lint()
      .pipe lint.reporter()

      # Start by compiling .coffee files
      .pipe sourcemaps.init()
      .pipe coffee()

      # Add JS files
      .pipe addsrc('app/**/*.js')

      # Concat everything
      .pipe gulpif config.concat, concat 'index.js'

      # Pre-process Angular.js annotations
      .pipe ngAnnotate add: yes, remove: yes, single_quotes: yes

      # Uglify
      .pipe gulpif config.minify, uglify()

      # Write out
      .pipe gulpif config.sourcemaps, sourcemaps.write()
      .pipe gulp.dest path.join config.paths.dest, 'app'
