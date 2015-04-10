angular.module 'Tranzit.app.shared.navbar', []
.controller 'NavbarController', ($scope, AppData) ->

  $scope.logout = -> AppData.logout()
