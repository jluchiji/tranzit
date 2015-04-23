angular.module 'Tranzit.app.views.home', []
.controller 'HomeController', ($scope, AppData, AppIntegration,
  TranzitRecipient, TranzitPackage) ->

  $('#scanner > input').focus()

  $scope.packages = [
    {
      tracking: "1Z6089649053538738"
      recipient: "4yocgPPOf6W"
      id: "mJs4kWo3"
      user: "QyvFzJE3"
    }
  ]

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

    if /^\;(.*)\?/.test($scope.scanner.value)
      # TODO Fix
      recvId = $scope.scanner.value.substr(1, $scope.scanner.value.length - 2)
      console.log recvId
      TranzitPackage.find(recipient: recvId, released: no)
      .success (info) ->
        console.log info
        $scope.scanner.state()
        $scope.packages = info
      .error (error) ->
        $scope.scanner.state 'error'
        console.log error
    else
      recipient = null
      AppIntegration.getInfo($scope.scanner.value)
      .then (info) ->
        TranzitRecipient.find(info.name, no)
      .then (recv) ->
        recipient = recv
        pkg =
          tracking: $scope.scanner.value,
          recipient: recv.id
        AppData.createPackage(pkg)
      .success (entry) ->
        $scope.packages.unshift _.extend entry, recipientName: recipient.name
        $scope.session().stats.unclaimed.count++
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
