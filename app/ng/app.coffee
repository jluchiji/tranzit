#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team



# Main application module file
angular.module 'Tranzit.app', [
  # Third-party dependencies
  'ui.router',
  'ui.bootstrap',
  'ngStorage',
  #'ngAnimate',
  #'anim-in-out',

  # First-party dependencies
  'Tranzit.config',
  'Tranzit.api.auth',
  'Tranzit.api.user',
  'Tranzit.api.recipient',
  'Tranzit.api.location',
  'Tranzit.api.package',
  'Tranzit.api.session',
  'Tranzit.app.events',
  'Tranzit.app.const',
  'Tranzit.app.data',
  'Tranzit.app.routing',
  'Tranzit.app.session',
  'Tranzit.app.directives',
  'Tranzit.app.ctrl.root',

  # Shared
  'Tranzit.app.shared.navbar',

  # Views
  'Tranzit.app.views.login',
  'Tranzit.app.views.home',
  'Tranzit.app.views.settings',
  'Tranzit.app.views.packageScan'
]

# Configure Underscore.js to recognize /:param style URL templates
.config ->
  _.templateSettings =
    evaluate: /:!([A-Za-z0-9]+)/g
    interpolate: /:([A-Za-z0-9]+)/g
    escape: /::([A-Za-z0-9]+)/g

.config ($provide) ->
  $provide.decorator '$q', ($delegate) ->
    defer = $delegate.defer
    _when = $delegate.when
    reject = $delegate.reject
    all = $delegate.all
    # Extend promises with non-returning handlers

    decoratePromise = (promise) ->
      promise._then = promise.then

      promise.then = (thenFn, errFn, notifyFn) ->
        p = promise._then(thenFn, errFn, notifyFn)
        decoratePromise p

      promise.success = (fn) ->
        promise.then (value) ->
          fn value
          return
        promise

      promise.error = (fn) ->
        promise.then null, (value) ->
          fn value
          return
        promise

      promise

    $delegate.defer = ->
      deferred = defer()
      decoratePromise deferred.promise
      deferred

    $delegate.when = ->
      p = _when.apply(this, arguments)
      decoratePromise p

    $delegate.reject = ->
      p = reject.apply(this, arguments)
      decoratePromise p

    $delegate.all = ->
      p = all.apply(this, arguments)
      decoratePromise p

    $delegate
  return

.run ($state, AppSession, AppEvents) ->

  $state.go 'login'

  AppEvents.on '$stateChangeStart', (e, to) ->

    if to.name is 'login' then return

    if not AppSession.user()
      e.preventDefault()
      $state.go 'login'

# Extend Underscore.js
_.mixin
  # Creates a diff object
  diff: (ori, mod, proplist) ->
    result = { }

    for prop in proplist
      if ori[prop] isnt mod[prop]
        result[prop] = mod[prop]

    return result
