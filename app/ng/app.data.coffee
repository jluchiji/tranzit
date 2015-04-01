#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team
angular.module 'Tranzit.app.data', []
.service 'AppData', ($state, AppSession, AppEvents, EventNames, TranzitAuth) ->

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
    if (credentials)
      TranzitAuth.authenticate(credentials, remember)
        .success (user) -> AppEvents.event EventNames.LoginSuccess, user
        .error (error) -> AppEvents.event EventNames.LoginFailure, error
    else
      # TODO Detect token

  # ------------------------------------------------------------------------- #
  # Logout                                                                    #
  # ------------------------------------------------------------------------- #
  @logout = ->
    TranzitAuth.destroy
      .success (user) -> AppEvents.event EventNames.LogoutSuccess, user
      .error (error) -> AppEvents.event EventNames.LogoutFailure, error

  # ------------------------------------------------------------------------- #
  # Update User                                                               #
  # ------------------------------------------------------------------------- #
  @updateUser = (password, params) ->
    TranzitUser.updateUser(password, params)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error


  #### SPRINT 2 ####  

  ## Package functions ##

  # ------------------------------------------------------------------------- #
  # Create Package                                                            #
  # ------------------------------------------------------------------------- #
  @create = (package) ->
    TranzitPackage.create(package)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error

  # ------------------------------------------------------------------------- #
  # Update Package                                                            #
  # ------------------------------------------------------------------------- #
  @update = (package) ->
    TranzitPackage.update(package)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error

  # ------------------------------------------------------------------------- #
  # Delete Package                                                            #
  # ------------------------------------------------------------------------- #
  @delete = (package) ->
    TranzitPackage.delete(package)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error


  ## Location functions ##

  # ------------------------------------------------------------------------- #
  # Create Location                                                           #
  # ------------------------------------------------------------------------- #
  @create = (location) ->
    TranzitLocation.create(location)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error

  # ------------------------------------------------------------------------- #
  # Update Location                                                           #
  # ------------------------------------------------------------------------- #
  @update = (location) ->
    TranzitLocation.update(location)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error

  # ------------------------------------------------------------------------- #
  # Delete Location                                                           #
  # ------------------------------------------------------------------------- #
  @delete = (location) ->
    TranzitLocation.delete(location)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error


  ## Recipient Functions ##

  # ------------------------------------------------------------------------- #
  # Create Recipient                                                          #
  # ------------------------------------------------------------------------- #
  @create = (recipient) ->
    TranzitRecipient.create(recipient)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error

  # ------------------------------------------------------------------------- #
  # Update Recipient                                                          #
  # ------------------------------------------------------------------------- #
  @update = (recipient) ->
    TranzitRecipient.update(recipient)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error

  # ------------------------------------------------------------------------- #
  # Delete Recipient                                                          #
  # ------------------------------------------------------------------------- #
  @delete = (recipient) ->
    TranzitRecipient.delete(recipient)
      .error (error) -> AppEvents.event EventNames.RemoteCallError, error


  return @