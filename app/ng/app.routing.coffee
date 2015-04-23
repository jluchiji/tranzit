angular.module 'Tranzit.app.routing', []
.config ($stateProvider, $urlRouterProvider) ->



  $stateProvider
    .state(
      'login',
      url: '/login',
      templateUrl: 'views/login/login.html',
      controller: 'LoginController'
    )
    .state(
      'home',
      url: '/home',
      templateUrl: 'views/home/home.html',
      controller: 'HomeController'
    )
    .state(
      'settings',
      url: '/settings',
      templateUrl: 'views/settings/settings.html',
      controller: 'SettingsController'
    )
    .state(
      'packageScan',
      url: '/packageScan',
      templateUrl: 'views/packageScan/packageScan.html',
      controller: 'PackageScanController'
    )
    .state(
      'search',
      url: '/search',
      templateUrl: 'views/search/search.html',
      controller: 'SearchController'
    )

# for future sprints, add more ".state"s
