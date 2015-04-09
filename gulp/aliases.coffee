# --------------------------------------------------------------------------- #
# wyvernzora.ninja build script.                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Denis Luchkin-Zhou                                         #
# See LICENSE.md for terms of distribution.                                   #
# --------------------------------------------------------------------------- #
sequence = require 'run-sequence'

module.exports = (gulp, config) ->

  gulp.task 'default', ->
    sequence(
      'all:clean',
      'all:build'
    )

  gulp.task 'all:clean', ['server:clean', 'client:clean']

  gulp.task 'all:build', ['server:build', 'client']


  gulp.task 'client', ['bower', 'client:assets', 'client:markup', 'client:scripts', 'client:styles']

  gulp.task 'client:markup', ['client:html', 'client:jade']

  gulp.task 'bower', ['bower:scripts', 'bower:styles', 'bower:fonts']

  gulp.task 'server', ['server:build']

  gulp.task 'server:build', ['server:scripts', 'server:config']

  gulp.task 'live-dev', ['default', 'server:launch', 'client:watch']
