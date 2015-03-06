# --------------------------------------------------------------------------- #
# tranzit-server build script.                                                #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Michael Schloss                                            #
# See LICENSE.md for terms of distribution.                                   #
# --------------------------------------------------------------------------- #

module.exports = (gulp, config) ->

  # This task builds the main server scripts
  gulp.task 'server:scripts', ->

    coffee = require 'gulp-coffee'
    coffeeLint = require 'gulp-coffeelint'
    gulpIf = require 'gulp-if'
    plumber = require 'gulp-plumber'
    sourceMaps = require 'gulp-soucemaps'

    gulp.src ['server/**/*.coffee'], base: './server'
        .pipe plumber()
        .pipe coffeeLint()
        .pipe coffeeLint.reporter()
        .pipe sourceMaps.init()
        .pipe coffee()
        .pipe gulpIf config.sourceMaps, sourceMaps.write('./')
        .pipe gulp.dest config.paths.dest

  # This task builds the configuration files for the server
  gulp.task 'server:config', ['server:config:sql'], ->
    path = require 'path'

    gulp.src ['config/**/*.{json,yml}'], base: './config'
        .pipe gulp.dest path.join config.paths.dest, 'config'

  # This task uses a regex to remove comments from the .SQL files
  gulp.task 'server:config:sql', ->

    path    = require 'path'
    replace = require 'gulp-replace'

    gulp.src ['config/**/*.sql'], base: './config'
      .pipe replace /(?:#.+\n)|(?:\/\/.+\n)|(?:\-\-.+\n)|(?:\/\*[\s\S]*\*\/)/g, ''
      .pipe gulp.dest path.join config.paths.dest, 'config'
