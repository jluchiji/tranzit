angular.module 'Tranzit.app.views.settings', []
.controller 'SettingsController', ($scope, AppSession)->

  # Get the user from session
  user = AppSession.user()
  # Make a backup copy of the user info
  original =
    firstName: user.firstName
    lastName:  user.lastName
    password: ''

  # Make a copy of the user info
  $scope.userInfo =
    firstName: user.firstName
    lastName:  user.lastName
    password: ''



  $scope.hasChanges = ->
    diff = _.diff original, $scope.userInfo, ['firstName', 'lastName', 'password']
    return diff and _.keys(diff).length isnt 0
