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

  # ------------------------------------------------------------------------- #
  # Create Package                                                            #
  # ------------------------------------------------------------------------- #
  @create = (package) ->
    # TODO

  # ------------------------------------------------------------------------- #
  # Update Information about Packages                                         #
  # ------------------------------------------------------------------------- #
  @update = ->
    # TODO

  # ------------------------------------------------------------------------- #
  # Pickup Package                                                            #
  # ------------------------------------------------------------------------- #
  @pickup = (package) ->
    # TODO

  # ------------------------------------------------------------------------- #
  # Delete Package                                                            #
  # ------------------------------------------------------------------------- #
  @delete = (package) ->
    # TODO


  return @