angular.module 'Tranzit.app.views.login', []
.controller 'LoginController', ($scope, $state, $localStorage, AppData, AppEvents) ->

  # Login Form Multistate
  $scope.loginForm =
    'shake':
      class: ''
      callback: ->
        @state()
        $(@element).removeClass('shake').animate nothing:null, 1, ->
          $(@).addClass('shake')

  $scope.loginButton =
    'loading':
      class: 'loading disabled'

  # Initialize empty credentials
  $scope.credentials =
    email: ''
    password: ''
    remember: yes

  # Detect token in local storage and attempt to login
  if $localStorage.token
    AppData.login($localStorage.token)

  # Detect last user
  if $localStorage.lastUser
    $scope.credentials.email = $localStorage.lastUser

  $scope.login = ->
    $scope.loginButton.state 'loading'
    AppData.login($scope.credentials, $scope.credentials.remember)
      .success (user) ->
        $scope.loginButton.state()
      .error (err) ->
        $scope.loginButton.state()
        $scope.loginForm.state 'shake'
