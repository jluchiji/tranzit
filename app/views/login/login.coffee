angular.module 'Tranzit.app.views.login', []
.controller 'LoginController', ($scope, $state, AppData, AppEvents) ->

  # Login Form Multistate
  $scope.loginForm =
    'shake':
      class: ''
      callback: ->
        @state()
        $(@element).removeClass('shake').animate nothing:null, 1, ->
          $(@).addClass('shake')

  # Initialize empty credentials
  $scope.credentials =
    email: ''
    password: ''
    remember: no


  $scope.login = ->
    AppData.login($scope.credentials, $scope.credentials.remember)
      .success (user) -> $state.go 'home'
      .error (err) -> $scope.loginForm.state 'shake'
