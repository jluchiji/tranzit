
module.exports = (gulp, config) ->

  gulp.task 'client:watch', ->

    gulp.watch ['app/**/*.coffee', 'app/**/*.js'], ['client:scripts']
    gulp.watch ['app/**/*.less', 'app/**/*.css'], ['client:styles']
    gulp.watch ['app/**/*.jade', 'app/**/*.html'], ['client:markup']
    gulp.watch ['assets/**/*'], ['client:assets']
    gulp.watch ['server/**/*.coffee', 'server/**/*.js'], ['server:scripts']
