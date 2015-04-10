#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team
angular.module 'Tranzit.app.data', []
.service 'AppData', ($state, AppSession, AppEvents, EventNames,
                     TranzitAuth, TranzitUser, TranzitAuthSession) ->

  # Keep these references just in case
  self = @
  session = AppSession

  # Cache, not used at this point
  cache = { }


  #### SPRINT 1 ####

  # ------------------------------------------------------------------------- #
  # Authentication                                                            #
  # ------------------------------------------------------------------------- #
  @login = (credentials, remember) ->
    promise =
      if _.isString(credentials)
        TranzitAuth.renew(credentials)
      else
        TranzitAuth.authenticate(credentials, remember)
    promise
      .success (user) -> AppEvents.event EventNames.LoginSuccess, user
      .error (error) -> AppEvents.event EventNames.LoginFailure, error

  # ------------------------------------------------------------------------- #
  # Logout                                                                    #
  # ------------------------------------------------------------------------- #
  @logout = ->
    TranzitAuthSession.destroy()
    AppEvents.event EventNames.LogoutSuccess

  # ------------------------------------------------------------------------- #
  # Update User                                                               #
  # ------------------------------------------------------------------------- #
  @updateUser = (password, params) ->
    TranzitUser.updateUser(password, params)
      .success (user) -> TranzitAuthSession.update(user)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error


  #### SPRINT 2 ####

  ## Package functions ##

  # ------------------------------------------------------------------------- #
  # Create Package                                                            #
  # ------------------------------------------------------------------------- #
  @createPackage = (pkg) ->
    TranzitPackage.create(pkg)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error

  # ------------------------------------------------------------------------- #
  # Update Package                                                            #
  # ------------------------------------------------------------------------- #
  @updatePackage = (pkg) ->
    TranzitPackage.update(pkg)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error

  # ------------------------------------------------------------------------- #
  # Delete Package                                                            #
  # ------------------------------------------------------------------------- #
  @deletePackage = (pkg) ->
    TranzitPackage.delete(pkg)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error


  ## Location functions ##

  # ------------------------------------------------------------------------- #
  # Create Location                                                           #
  # ------------------------------------------------------------------------- #
  @createLocation = (location) ->
    TranzitLocation.create(location)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error

  # ------------------------------------------------------------------------- #
  # Update Location                                                           #
  # ------------------------------------------------------------------------- #
  @updateLocation = (location) ->
    TranzitLocation.update(location)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error

  # ------------------------------------------------------------------------- #
  # Delete Location                                                           #
  # ------------------------------------------------------------------------- #
  @deleteLocation = (location) ->
    TranzitLocation.delete(location)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error


  ## Recipient Functions ##

  # ------------------------------------------------------------------------- #
  # Create Recipient                                                          #
  # ------------------------------------------------------------------------- #
  @createRecipient = (recipient) ->
    TranzitRecipient.create(recipient)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error

  # ------------------------------------------------------------------------- #
  # Update Recipient                                                          #
  # ------------------------------------------------------------------------- #
  @updateRecipient = (recipient) ->
    TranzitRecipient.update(recipient)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error

  # ------------------------------------------------------------------------- #
  # Delete Recipient                                                          #
  # ------------------------------------------------------------------------- #
  @deleteRecipient = (recipient) ->
    TranzitRecipient.delete(recipient)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error


  return @

  # ------------------------------------------------------------------------- #
  # Event handling                                                            #
  # ------------------------------------------------------------------------- #
  AppEvents.on EventNames.LogoutSuccess, (e, data) ->
    $state.go 'login'

  AppEvents.on EventNames.LoginSuccess, (e, data) ->
    $state.go 'home'

  return @
