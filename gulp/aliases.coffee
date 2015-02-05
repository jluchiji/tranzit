# --------------------------------------------------------------------------- #
# wyvernzora.ninja build script.                                              #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Copyright © 2015 Denis Luchkin-Zhou                                         #
# See LICENSE.md for terms of distribution.                                   #
# --------------------------------------------------------------------------- #
module.exports = (gulp, config) ->



  gulp.task 'client', ['bower', 'client:assets', 'client:markup', 'client:scripts', 'client:styles']

  gulp.task 'client:markup', ['client:html', 'client:jade']

  gulp.task 'bower', ['bower:scripts']

  gulp.task 'server:build', ['server:scripts', 'server:config']
