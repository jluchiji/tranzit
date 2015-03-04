#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team
angular.module 'Tranzit.app.directives', []

# --------------------------------------------------------------------------- #
# Angular.js directive version of Kernite.Multistate                          #
# --------------------------------------------------------------------------- #
.directive 'ckMultistate', ->
  restrict: 'A'
  scope:
    config: '=ckMultistate'
  link: (scope, element, attr) ->
    config = scope.config
    # Add default state to the config (if not already present)
    if not config.default
      config.default = class: '',  callback: null
    # Construct unique class table
    scope.classes = _.chain(config).map((v) -> (v.class ? '').split(' ')).
      flatten().uniq().compact().value().join(' ')
    # Save current state
    scope.state = 'default'

    # Make element accessible from config object
    config.element = element

    # Attach state method to the config variable
    config.state = (name, force) ->
      # Do not change state if already in the state; unless forced
      if (not force) and (scope.state is name) then return
      # if state not found, go to default
      if not config[name] then name = 'default'
      # Save current state
      scope.state = name
      # transition
      element.removeClass(scope.classes).addClass(config[name].class)
      if (config[name].callback) then config[name].callback.call(config)

# --------------------------------------------------------------------------- #
# HTML element background image                                               #
# --------------------------------------------------------------------------- #
.directive 'ckBg', ->
  restrict: 'A'
  scope:
    url: '=ckBg'
  link: (scope, element, attr) ->
    scope.$watch 'url', (url) ->
      def = element.attr('ck-bg-default')
      image = if url and url isnt '' then url else def
      if image then attr.$set 'style', 'background-image: url(\''+image+'\');'

# --------------------------------------------------------------------------- #
# Bootstrap modal (but better)                                                #
# --------------------------------------------------------------------------- #
.directive 'ckModal', ($q) ->
  restrict: 'A'
  scope:
    control: '=ckModal'
  link: (scope, element, attr) ->
    scope.control =
      $promise: null
      $show: ->
        @$promise = $q.defer()
        $(element).modal('show')
        return @$promise.promise
      $close: (result) ->
        $(element).modal('hide')
        @$promise.resolve(result)

# --------------------------------------------------------------------------- #
# You shall not drag!!                                                        #
# --------------------------------------------------------------------------- #
.directive 'ckNoDrag', ->
  restrict: 'A'
  link: (scope, element) ->
    $(element).on 'dragstart', -> no

# --------------------------------------------------------------------------- #
# Automatically focus whenever needed.                                        #
# --------------------------------------------------------------------------- #
.directive 'ckAutoFocus', ($timeout, $parse) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    model = $parse(attrs.ckAutoFocus)
    scope.$watch model, (value) ->
      if value then $timeout(-> element[0].focus())
