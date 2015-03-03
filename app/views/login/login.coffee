angular.module 'Tranzit.app.views.login', []
.controller 'LoginController', ($scope, $state, AppData, AppEvents) ->

  # Initialize empty credentials
  $scope.credentials =
    email: ''
    password: ''
    remember: no


  $scope.login = ->
    AppData.login($scope.credentials, $scope.credentials.remember)
      .success (user) -> $state.go 'home'
      .error (err) -> alert(err)
