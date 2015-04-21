angular.module 'Tranzit.app.views.home', []
.controller 'HomeController', ($scope, AppData, AppIntegration) ->

  $('#scanner > input').focus()

  $scope.viewState = null

  $scope.pendingPackages = null

  # Multistate: save account settings
  $scope.scannerSubmitBtn =
    'loading':
      class: 'loading disabled'

  $scope.scannerSubmit = ->
    console.log $scope.scannerInput
    $scope.scannerSubmitBtn.state 'loading'
    if not $scope.scannerInput
      $scope.reset()
    if /^\;.*\?/.test($scope.scannerInput)
      $scope.viewState = 'id'
    else
      $scope.viewState = 'tracking'
      AppIntegration.getInfo($scope.scannerInput)
        .success (info) ->
          $scope.recipient = info
          $scope.scannerSubmitBtn.state ''
          console.log info
        .error (error) -> console.log error


  $scope.reset = ->
    $scope.scannerInput = ''
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
