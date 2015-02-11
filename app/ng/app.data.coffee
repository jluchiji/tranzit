#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team
angular.module 'Tranzit.app.data', []
.service 'AppData', ($state, AppSession, TranzitAuth) ->

  # Keep these references just in case
  self = @
  session = AppSession

  # Cache, not used at this point
  cache = { }

  # ------------------------------------------------------------------------- #
  # Authentication                                                            #
  # ------------------------------------------------------------------------- #
  @login = (credentials, remember) ->
    # TODO Detect stored token and call renew instead of auth
    TranzitAuth.authenticate(email: 'test@tranzit.io', password: '11111111', no)
      .then ((user) -> console.log user), ((error) -> console.log error)


  return @
