angular.module 'Tranzit.app.views.home', []
.controller 'HomeController', ($scope, AppData, AppIntegration, TranzitRecipient) ->

  $('#scanner > input').focus()

  $scope.scanner =
    value: ''
    'loading':
      class: 'loading disabled'
    'success':
      class: 'success disabled'
      callback: -> setTimeout((=> @state 'default'), 1500)
    'error':
      class: 'error disabled'
      callback: -> setTimeout((=> @state 'default'), 1500)

  $scope.scanner.submit = ->
    $scope.error = null

    if not $scope.scanner.value
      $scope.scanner.state 'error'
      return

    $scope.scanner.state 'loading'

    if /^\;.*\?/.test($scope.scanner.value)

    else
      AppIntegration.getInfo($scope.scanner.value)
      .then (info) ->
        TranzitRecipient.find(info.name, no)
      .then (recv) ->
        pkg =
          tracking: $scope.scanner.value,
          recipient: recv.id
        AppData.createPackage(pkg)
      .success ->
        $scope.scanner.value = ''
        $scope.scanner.state 'success'
      .error (error) ->
        $scope.scanner.value = ''
        recoverRegErrors(error)
        $scope.scanner.state 'error'

  # Attempt to recover from registration errors
  recoverRegErrors = (error) ->
    # check if this is an issue with 3rd party API
    if error.src is 'tranzit.app.integration'
      $scope.error = 'Tracking number not recognized.'
    else if error.status is 404
      $scope.error = 'Could not find the package recipient.'
    else
      $scope.error = error.message
