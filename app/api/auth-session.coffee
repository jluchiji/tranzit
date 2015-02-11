#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team
angular.module 'Tranzit.api.session', []

# Authentication session
.service 'TranzitAuthSession', ($localStorage) ->

  # Initializes an authentication session
  @create = (user, remember) ->
    @user = user

    # If remember is true, store credentials in local storage
    if remember
      $localStorage.token = @user.token
      $localStorage.lastUser = @user.email

    # Return @ for chaining
    return @

  # Destroys the authentication session
  @destroy = ->
    # Remove user information from memory
    @user = null
    # Delete credentials from local storage
    $localStorage.token = null

  # Return the singleton
  return @
