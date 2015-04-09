# --------------------------------------------------------------------------- #
# wyvernzora.ninja build script.                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Denis Luchkin-Zhou                                         #
# See LICENSE.md for terms of distribution.                                   #
# --------------------------------------------------------------------------- #
module.exports = (gulp, config) ->

  gulp.task 'server:clean', ->

    del     = require 'del'
    vinyl   = require 'vinyl-paths'

    gulp.src ['./dist/*', '!./dist/app'], read: no
      .pipe vinyl del
