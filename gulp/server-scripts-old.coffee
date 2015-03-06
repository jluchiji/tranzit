# --------------------------------------------------------------------------- #
# wyvernzora.ninja build script.                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Denis Luchkin-Zhou                                         #
# See LICENSE.md for terms of distribution.                                   #
# --------------------------------------------------------------------------- #
module.exports = (gulp, config) ->

    gulp.task 'server:scripts', ->

      lint       = require 'gulp-coffeelint'
      coffee     = require 'gulp-coffee'
      gulpif     = require 'gulp-if'
      plumber    = require 'gulp-plumber'
      sourcemaps = require 'gulp-sourcemaps'

      gulp.src ['server/**/*.coffee'], base: './server'

        # Prevent crashes
        .pipe plumber()

        # Lint
        .pipe lint()
        .pipe lint.reporter()

        # Start by compiling .coffee files
        .pipe sourcemaps.init()
        .pipe coffee()

        # Write out
        .pipe gulpif config.sourcemaps, sourcemaps.write('./')
        .pipe gulp.dest config.paths.dest

    gulp.task 'server:config', ['server:config:sql'], ->

      path = require 'path'

      gulp.src ['config/**/*.{json,yml}'], base: './config'

        .pipe gulp.dest path.join config.paths.dest, 'config'

    # Strips comments from .sql script files
    gulp.task 'server:config:sql', ->

      path    = require 'path'
      replace = require 'gulp-replace'

      gulp.src ['config/**/*.sql'], base: './config'
        .pipe replace /(?:#.+\n)|(?:\/\/.+\n)|(?:\-\-.+\n)|(?:\/\*[\s\S]*\*\/)/g, ''
        .pipe gulp.dest path.join config.paths.dest, 'config'
