angular.module 'Tranzit.app.views.home', []
.controller 'HomeController', ($scope, AppData, AppIntegration,
  TranzitRecipient, TranzitPackage) ->

  $('#scanner > input').focus()

  $scope.packages = []

  $scope.currentRecvId = null

  TranzitPackage.find(limit: 20).then (data) ->
    $scope.packages = data

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
      if recvId.indexOf('=') isnt -1
        recvId = recvId.split('=')[2]
      $scope.scanner.value = ";#{recvId}?"
      console.log recvId
      TranzitPackage.find(recipient: recvId)
      .success (info) ->
        console.log info
        info = _.filter(info, (i) -> i.released is null)
        $scope.scanner.state()
        $scope.packages = info
        $scope.currentRecvId = recvId
      .error (error) ->
        $scope.scanner.state 'error'
        console.log error
    else
      recipient = null
      AppIntegration.getInfo($scope.scanner.value)
      .then (info) ->
        TranzitRecipient.find(info.name, yes)
      .then (recv) ->
        recipient = _.map(Object.keys(recv), (i) -> recv[i])[0]s
        pkg =
          tracking: $scope.scanner.value,
          recipient: recipient.id
        AppData.createPackage(pkg)
      .success (entry) ->
        $scope.packages.unshift _.extend entry, recipientName: recipient.name, recipientAddress: recipient.address
        $scope.session().stats.unclaimed.count++
        $scope.scanner.value = ''
        $scope.scanner.state 'success'
      .error (error) ->
        $scope.scanner.value = ''
        recoverRegErrors(error)
        $scope.scanner.state 'error'

  $scope.release =
    'loading':
      class: 'loading disabled'
    'success':
      class: 'success disabled'
      callback: -> setTimeout((=> @state 'default'), 1500)
    'error':
      class: 'error disabled'
      callback: -> setTimeout((=> @state 'default'), 1500)

  $scope.releasePackages = ->
    $scope.release.state 'loading'
    TranzitPackage.release($scope.currentRecvId)
    .success ->
      for pkg in $scope.packages
        pkg.released = new Date().getTime() / 1000
      $scope.release.state 'success'
      $scope.currentRecvId = null
      $scope.scanner.value = ''

      $scope.session().stats.unclaimed.count--
      $scope.session().stats.last24.count++

    .error ->
      $scope.release.state 'error'


  # Attempt to recover from registration errors
  recoverRegErrors = (error) ->
    # check if this is an issue with 3rd party API
    if error.src is 'tranzit.app.integration'
      $scope.error = 'Tracking number not recognized.'
    else if error.status is 404
      $scope.error = 'Could not find the package recipient.'
    else
      $scope.error = error.message
