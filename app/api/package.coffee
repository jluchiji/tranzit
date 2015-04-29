#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright � 2015 Tranzit Development Team
angular.module 'Tranzit.api.package', ['Tranzit.config']

# Authentication API service
.service 'TranzitPackage', ($http, $localStorage, $q, ApiConfig, TranzitAuthSession) ->

  # Keep a reference of @ in case we need it later in nested functions
  self = @

  @findByRecipient = (params) -> # specifically meant for recipient id as param
    url = ':host/api/packages'

    # HTTP call details here
    config =
      method:   'GET'
      url:      _.template(url)(host: ApiConfig.host)
      params:   _.extend {}, params
      headers:
        'Content-Type': 'application/json'
        'X-Tranzit-Auth': TranzitAuthSession.user?.token

    # Send request and generate a promise
    return $http(config).then (data) ->
      return data.data.result

  @findByLocation = (params) ->
    url = ':host/api/packages'

    # HTTP call details here
    config =
      method:   'GET'
      url:      _.template(url)(host: ApiConfig.host)
      params:   _.extend {}, params
      headers:
        'Content-Type': 'application/json'
        'X-Tranzit-Auth': TranzitAuthSession.user?.token

    # Send request and generate a promise
    return $http(config).then (data) ->
      return data.data.result

  @findByDate = (params) -> # unix timestamp as param
    url = ':host/api/packages'

    # HTTP call details here
    config =
      method:   'GET'
      url:      _.template(url)(host: ApiConfig.host)
      params:   _.extend {}, params
      headers:
        'Content-Type': 'application/json'
        'X-Tranzit-Auth': TranzitAuthSession.user?.token

    # Send request and generate a promise
    return $http(config).then (data) ->
      return data.data.result

  @create = (pkg) ->
    url = ':host/api/packages'

    # HTTP call details here
    config =
      method:   'POST'
      url:      _.template(url)(host: ApiConfig.host)
      data:     JSON.stringify _.extend({}, pkg)
      headers:
        'Content-Type': 'application/json'
        'X-Tranzit-Auth': TranzitAuthSession.user?.token

    # Send request and generate a promise
    return $http(config).then (data) ->
      return data.data.result

  @update = (pkg) ->
    url = ':host/api/packages'

    # HTTP call details here
    config =
      method:   'PUT'
      url:      _.template(url)(host: ApiConfig.host)
      data:     JSON.stringify _.extend({}, pkg)
      headers:
        'Content-Type': 'application/json'
        'X-Tranzit-Auth': TranzitAuthSession.user?.token

    # Send request and generate a promise
    return $http(config).then (data) ->
      return data.data.result

  @delete = (pkg) ->
    url = ':host/api/packages'

    # HTTP call details here
    config =
      method:   'DELETE'
      url:      _.template(url)(host: ApiConfig.host)
      data:     JSON.stringify _.extend({}, pkg)
      headers:
        'Content-Type': 'application/json'
        'X-Tranzit-Auth': TranzitAuthSession.user?.token

    # Send request and generate a promise
    return $http(config).then (data) ->
      return data.data.result

  return @
