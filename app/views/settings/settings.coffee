angular.module 'Tranzit.app.views.settings', []
.controller 'SettingsController', ($scope, AppSession)->

  # Make a copy of current user info
  user = AppSession.user()
  $scope.userInfo =
    firstName: user.firstName
    lastName:  user.lastName
    
