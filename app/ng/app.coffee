#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team



# Main application module file
angular.module 'Tranzit.app', [
  # Third-party dependencies
  'ui.router',
  'ngStorage',

  # First-party dependencies
  'Tranzit.config',
  'Tranzit.api.auth',
  'Tranzit.api.session',
  'Tranzit.app.data',
  'Tranzit.app.routing',
  'Tranzit.app.session',
  'Tranzit.app.ctrl.root'

]

# Configure Underscore.js to recognize /:param style URL templates
.config ->
  _.templateSettings =
    evaluate: /:!([A-Za-z0-9]+)/g
    interpolate: /:([A-Za-z0-9]+)/g
    escape: /::([A-Za-z0-9]+)/g
