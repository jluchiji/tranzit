#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team
angular.module 'Tranzit.api.user', ['Tranzit.config']

# Authentication API service
.service 'TranzitUser', ($http, $localStorage, $q, ApiConfig, TranzitAuthSession) ->

  # Keep a reference of @ in case we need it later in nested functions
  self = @

  @updateUser = (password, params) ->
    url = ':host/api/users'

    # HTTP call details here
    config =
      method:   'PUT'
      url:      _.template(url)(host: ApiConfig.host)
      data:     JSON.stringify _.extend({}, params, password: password)
      headers:  
        'Content-Type': 'application/json'
        'X-Tranzit-Auth': TranzitAuthSession.user?.token

    # Send request and generate a promise
    return $http(config).then (data) ->
      return data.data.result

  return @
