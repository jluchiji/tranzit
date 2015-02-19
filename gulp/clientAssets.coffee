#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team

module.exports = (gulp, config) ->
  gulp.task 'client-assets', ->
    path = require 'path'
    imagemin = require('gulp-imagemin');
    pngquant = require('imagemin-pngquant');
    gulp.src['assets/**'], base: './assets'
      `.pipe(imagemin({
         progressive: true,
         interlaced: true,
         multipass: true,
         svgoPlugins: [{removeViewBox: false}],
         use: [pngquant()]
       }))`
      .pipe gulp.dest path.join config.paths.dest, 'app/assets'

 # Attempt to translate javascript into coffeescript
#      .pipe imagemin
#        progressive: true
#        interlaced: true
#        multipass: true
#        svgoPlugins: [removeViewBox: false]
#        use: [pngquant ]