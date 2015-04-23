angular.module 'Tranzit.app.views.home', []
.controller 'HomeController', ($scope, AppData, AppIntegration, TranzitRecipient) ->

  $('#scanner > input').focus()

  $scope.pendingPackages = null


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
    if not $scope.scanner.value
      $scope.scanner.state 'error'
      return

    $scope.scanner.state 'loading'

    if /^\;.*\?/.test($scope.scanner.input)

    else
      # Get package info from shipping provider
      AppIntegration.getInfo($scope.scanner.input)
      .success (info) ->

        $scope.packageInfo.name = info.name
        $scope.packageInfo.address = info.address

        $scope.packageInfo.submit()
          .success -> $scope.scanner.state 'success'
          .error -> $scope.scanner.state 'error'

      # Shipping provided has no record of the tracking
      .error (error) ->
        $scope.scanner.state 'error'
        $scope.packageInfo.error = error


  $scope.packageInfo =
    value:  ''
    'loading':
      class: 'loading disabled'
    'success':
      class: 'success disabled'
      callback: -> setTimeout((=> @state 'default'), 1500)
    'error':
      class: 'error disabled'
      callback: -> setTimeout((=> @state 'default'), 1500)

  $scope.packageInfo.submit = ->

    $scope.packageInfo.state 'loading'

    # Find matching recipient from database
    TranzitRecipient.find($scope.packageInfo.name, no)
    .then (recv) ->
      $scope.recipient = recv
      $scope.recipient.tracking = $scope.scannerInput
      $scope.scanner.input = ''
      $scope.scanner.state 'success'
      console.log recv

    # Did not find exact match for recipient
    .error (error) ->
      if error.status is 404
        alert('404')

  $scope.recipient =
    submit: -> undefined

  $scope.reset = ->
    $scope.scannerInput = ''
    $scope.viewState = null
    $scope.recipient = null


  registerPackage = ->
    $scope.recipient.id = $scope.recipient.id.substr(16,10)
    $scope.submitButton.state 'loading'
    AppData.createRecipient($scope.recipient)
      .then (recipient) ->
        pkg =
          tracking: $scope.scanner.input
          recipient: recipient.id
        console.log pkg
        AppData.createPackage(pkg)
      .then ->
        $scope.submitButton.state 'success'
        $scope.reset()
      .error (e) ->
        console.log e
        $scope.submitButton.state 'error'

  findPackages = ->
    id = $scope.scanner.input.substr(16,10)
    console.log id
    AppData.findByRecipient(id)
      .then (packages) -> $scope.pendingPackages = packages
