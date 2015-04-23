angular.module 'Tranzit.app.views.search', []
.controller 'SearchController', ($scope, AppData) ->

  $('#scanner').focus()

  $scope.viewState = null
