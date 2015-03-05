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


  # 'Private' functions
  getChanges = ->
    return _.diff original, $scope.userInfo, ['firstName', 'lastName', 'password']

  # 'Public' functions
  $scope.hasChanges = ->
    diff = getChanges()
    return diff and _.keys(diff).length isnt 0

  $scope.needPassword = ->
    diff = getChanges()
    return diff.password and not $scope.userInfo.currentPassword

  $scope.needVerify = ->
    diff = getChanges()
    return diff.password and $scope.userInfo.password isnt $scope.userInfo.passwordVerify
