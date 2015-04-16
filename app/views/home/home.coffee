angular.module 'Tranzit.app.views.home', []
.controller 'HomeController', ($scope, AppData) ->

  $('#scanner').focus()

  $scope.viewState = null

  $scope.pendingPackages = null

  # Multistate: save account settings
  $scope.submitButton =
    'loading':
      class: 'loading disabled'
    'success':
      class: 'success disabled'
      callback: -> setTimeout((=> @state 'default'), 3000)
    'error':
      class: 'error disabled'
      callback: -> setTimeout((=> @state 'default'), 3000)

  $scope.onScannerInput = ->
    if not $scope.scanner.input
      $scope.reset()
    if /^\;.*\?/.test($scope.scanner.input)
      $scope.viewState = 'id'
    else
      $scope.viewState = 'tracking'

  $scope.reset = ->
    $scope.scanner.input = ''
    $scope.viewState = null
    $scope.recipient = null

  $scope.submit = ->
    if $scope.viewState is 'tracking'
      registerPackage()
      return

    if $scope.viewState is 'id'
      findPackages()
      return

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
