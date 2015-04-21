#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright � 2015 Tranzit Development Team
angular.module 'Tranzit.api.stats', ['Tranzit.config']

# Authentication API service
.service 'TranzitStats', ($http, ApiConfig, TranzitAuthSession) ->


  # Keep a reference of @ in case we need it later in nested functions
  self = @

  @get = (password, params) ->
    url = ':host/api/stats'

    # HTTP call details here
    config =
      method:   'GET'
      url:      _.template(url)(host: ApiConfig.host)
      headers:
        'X-Tranzit-Auth': TranzitAuthSession.user?.token

    # Send request and generate a promise
    return $http(config).then (data) ->
      return data.data.result

  return @
