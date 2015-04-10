# --------------------------------------------------------------------------- #
# tranzit-server build script.                                                #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Michael Schloss                                            #
# See LICENSE.md for terms of distribution.                                   #
# --------------------------------------------------------------------------- #

module.exports = (gulp, config) ->

  # This task cleans the distribuition directory by removing all built
  #   files
  gulp.task 'server:clean', ->
    del = require 'del'
    vinyl = require 'vinyl-paths'

    gulp.src ['./dist/*', '!./dist/app'], read: no
      .pipe vinyl del
