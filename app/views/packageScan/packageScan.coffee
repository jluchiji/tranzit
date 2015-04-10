angular.module 'Tranzit.app.views.packageScan', []
.controller 'PackageScanController', ($scope) ->
  undefined

.controller 'PackagePackageScanController', ($scope, TranzitAuthSession, AppSession, AppData) ->

  #Original for comparison
  $scope.original =
    firstName: ''
    lastName: ''
    email: ''

  $scope.packageOriginal =
    trackingNumber: ''

  #Make a copy
  $scope.recipient =
    firstName: ''
    lastName: ''
    email: ''

  $scope.package =
    trackingNumber: ''

  #Button States
  $scope.lookUpEmailButton =
    'loading':
      class: 'loading disabled'
    'success':
      class: 'success disabled'
      callback: -> setTimeout((=> @state 'default'), 3000)
    'error':
      class: 'error disabled'
      callback: -> setTimeout((=> @state 'default'), 3000)

  $scope.addPackageButton =
    'loading':
      class: 'loading disabled'
    'success':
      class: 'success disabled'
      callback: -> setTimeout((=> @state 'default'), 3000)
    'error':
      class: 'error disabled'
      callback: -> setTimeout((=> @state 'default'), 3000)

  $scope.badEmail = no

  #Functions

  getRecipientChanges = ->
    return _.diff original, $scope.recipient, ['firstName', 'lastName', 'email']

  getPackageChanges = ->
    return _.diff packageOriginal, $scope.package, ['trackingNumber']

  $scope.hasRecipientChanges = ->
    diff = getRecipientChanges()
    return diff and _.keys(diff).length isnt 0

  $scope.needEmail = ->
    diff = getRecipient()
    return diff.email and not $scope.recipient.email

  $scope.reset = ->
    $scope.recipient =
      firstName: ''
      lastName:  ''
      email: ''
    $scope.package =
      trackingNumber = ''

  $scope.lookUpEmail = ->

    #No Changes Made
    if not $scope.hasRecipientChanges()
      $scope.lookUpEmailButton.state 'success'
      return

    # Shorthand
    u = $scope.userInfo

    #Errors
    if $scope.needEmail()
      $scope.submitButton.state 'error'
      return

    $scope.badPassword = no
