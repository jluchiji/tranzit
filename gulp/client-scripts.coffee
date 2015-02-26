#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team

#
# The purpose of this file is to allow all client logic scripts to be 
# to be easily checked for syntax and logic errors as well as bundled
# together with all necessary libraries and frameworks
#
# rosenbea
#

module.exports = (gulp, config) ->

  gulp.task 'client:scripts', ->

    # add the necessary dependencies
    path = require 'path'
    lint = require 'gulp-coffeelint'
    addsrc = require 'gulp-add-src'
    gulpif = require 'gulp-if'
    concat = require 'gulp-concat'
    coffee = require 'gulp-coffee'
    uglify = require 'gulp-uglify'
    plumber = require 'gulp-plumber'
    sourcemaps = require 'gulp-sourcemaps'
    ngAnnotate = require 'gulp-ng-annotate'

    # gather all coffeescript source files in /app/...
    gulp.src ['app/**/*.coffee'], base: './app'