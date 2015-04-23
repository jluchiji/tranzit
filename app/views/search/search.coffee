angular.module 'Tranzit.app.views.search', []
.controller 'SearchController', ($scope, AppData) ->

  $('#scanner').focus()

  $scope.viewState = null

  $scope.onButtonPress = ->
    if not $scope.scanner.input
      $scope.reset()
    if /^\;.*\?/.test($scope.scanner.input)
      $scope.viewState = 'id'
    else
      $scope.viewState = 'tracking'

  $scope.reset = ->
    $scope.viewState = null
