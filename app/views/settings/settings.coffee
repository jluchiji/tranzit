angular.module 'Tranzit.app.views.settings', []
.controller 'SettingsController', ($scope, AppSession) ->
  undefined

.controller 'AccountSettingsController', ($scope, TranzitAuthSession, AppSession, AppData) ->

  # Make a backup copy of the user info
  original =
    firstName: AppSession.user().firstName
    lastName:  AppSession.user().lastName
    password: ''

  # Make a copy of the user info
  $scope.userInfo =
    firstName: AppSession.user().firstName
    lastName:  AppSession.user().lastName
    password: ''

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

  $scope.badPassword = no

  # 'Private' functions
  getChanges = ->
    return _.diff original, $scope.userInfo, ['firstName', 'lastName', 'password']

  # 'Public' functions
  $scope.hasChanges = ->
    diff = getChanges()
    return diff and _.keys(diff).length isnt 0

  $scope.needPassword = ->
    diff = getChanges()
    return diff.password and not $scope.userInfo.currentPassword

  $scope.needVerify = ->
    diff = getChanges()
    return diff.password and $scope.userInfo.password isnt $scope.userInfo.passwordVerify

  $scope.reset = ->
    $scope.userInfo =
      firstName: AppSession.user().firstName
      lastName:  AppSession.user().lastName
      password: ''
      passwordVerofy: ''
      currentPassword: ''

  $scope.submit = ->

    if not $scope.hasChanges()
      $scope.submitButton.state 'success'
      return

    # Shorthand
    u = $scope.userInfo

    # Validity of first name & last name checked by HTML form

    # Validity of password
    if $scope.needPassword() and not u.currentPassword
      $scope.submitButton.state 'error'
      return
    if $scope.needVerify() and u.password isnt u.passwordVerify
      $scope.userInfo.passwordVerify = ''
      $scope.submitButton.state 'error'
      return

    $scope.badPassword = no
    $scope.submitButton.state 'loading'
    AppData.updateUser(u.currentPassword, getChanges())
      .success ->
        $scope.submitButton.state 'success'
        $scope.reset()
      .error (error) ->
        if (error.status is 401)
          $scope.badPassword = yes
          $scope.userInfo.currentPassword = ''
        $scope.submitButton.state 'error'
