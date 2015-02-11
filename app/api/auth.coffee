#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team
angular.module 'Tranzit.api.auth', ['Tranzit.config']

# Authentication API service
.service 'TranzitAuth', ($http, $localStorage, $q, ApiConfig, TranzitAuthSession) ->

  # Keep a reference of @ in case we need it later in nested functions
  self = @

  @authenticate = (credentials, remember) ->
    url = ':host/api/auth'

    # HTTP call details here
    config =
      method:   'POST'
      url:      _.template(url)(host: ApiConfig.host)
      data:     JSON.stringify credentials
      headers:  'Content-Type': 'application/json'

    # Send request and generate a promise
    return $http(config).then (data) ->
      TranzitAuthSession.create data.data.result, remember
      return data.data.result

  return @
