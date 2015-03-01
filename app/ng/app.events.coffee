
# --------------------------------------------------------------------------- #
#                                                                             #
# Application-wide events & routing                                           #
#                                                                             #
# --------------------------------------------------------------------------- #
angular.module 'Tranzit.app.events', []
.service 'AppEvents', ($rootScope, $location) ->

  # Shorthands
  self = @

  # ------------------------------------------------------------------------- #
  # App-wide event broadcast                                                  #
  # ------------------------------------------------------------------------- #

  # Broadcasts the specified event across the entire application.
  # Shorthand for `$rootScope.$broadcast`
  @event = (event, data) ->
    $rootScope.$broadcast event, data
    console.log [ event, data ]

  # Attaches an event callback to the root application scope.
  # Shorthand for `$rootScope.$on`
  @on =  (event, fn) ->
    $rootScope.$on event, fn

  return @
