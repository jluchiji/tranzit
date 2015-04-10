angular.module 'Tranzit.app.views.home', []
.controller 'HomeController', ($scope) ->

  $('#scanner').focus()

  $scope.viewState = null

  $scope.pendingPackages = null

  # Multistate: save account settings
  $scope.submitButton =
    'loading':
      class: 'loading disabled'
    'success':
      class: 'success disabled'
      callback: -> setTimeout((=> @state 'default'), 3000)
    'error':
      class: 'error disabled'
      callback: -> setTimeout((=> @state 'default'), 3000)

  $scope.onScannerInput = ->
    if not $scope.scanner.input
      $scope.reset()
    if /^\;.*\?/.test($scope.scanner.input)
      $scope.viewState = 'id'
    else
      $scope.viewState = 'tracking'

  $scope.reset = ->
    $scope.scanner.input = ''
    $scope.viewState = null

  $scope.submit = ->
    undefined
