angular.module 'Tranzit.app.views.home', []
.controller 'HomeController', ($scope) ->

  $scope.viewState = null

  $scope.onScannerInput = ->
    if /^\;[0-9]+=[0-9]+=[0-9]+=[0-9]+\?/.test($scope.scanner.input)
      $scope.viewState = 'id'
    else
      $scope.viewState = 'tracking'

  $scope.reset = ->
    $scope.scanner.input = ''
    $scope.viewState = null

  $scope.submit = ->
    undefined
