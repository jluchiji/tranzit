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

  # Initialize empty credentials
  $scope.credentials =
    email: ''
    password: ''
    remember: yes

  # Detect token in local storage and attempt to login
  if $localStorage.token
    AppData.login($localStorage.token)


  $scope.login = ->
    AppData.login($scope.credentials, $scope.credentials.remember)
      .success (user) -> undefined
      .error (err) -> $scope.loginForm.state 'shake'
