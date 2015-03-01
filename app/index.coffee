#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team

angular.module 'Tranzit.app.ctrl.root', []
.controller 'RootController', ($scope, AppData, AppEvents, EventNames) ->

  AppEvents.on EventNames.LoginSuccess, (event, data) ->
    alert("Login success: #{data.firstName} #{data.lastName}")
  AppEvents.on EventNames.LoginFailure, (event, data) ->
    alert("Login failed: #{data}")

  $scope.click = ->
    AppData.login(email: 'test@tranzit.io', password: '11111111')
