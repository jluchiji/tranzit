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
    gulp.src['assets/**'], base: './assets'
      .pipe gulp.dest path.join config.paths.dest, 'app/assets'