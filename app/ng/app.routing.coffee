angular.module 'Tranzit.app.routing', []
.config ($stateProvider, $urlRouterProvider) ->

  $stateProvider
    .state(
      'login',
      url: '/login',
      templateUrl: 'views/login/login.html'
    )
