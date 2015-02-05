# --------------------------------------------------------------------------- #
# wyvernzora.ninja build script.                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Denis Luchkin-Zhou                                         #
# See LICENSE.md for terms of distribution.                                   #
# --------------------------------------------------------------------------- #
module.exports = (gulp, config) ->

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
