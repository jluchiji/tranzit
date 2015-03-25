#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team
angular.module 'Tranzit.api.recipient', ['Tranzit.config']

# Authentication API service
.service 'TranzitRecipient', ($http, $localStorage, $q, ApiConfig, TranzitAuthSession) ->

  # Keep a reference of @ in case we need it later in nested functions
  self = @

  @getRecipient = (recipientID) -> # TODO
    url = ':host/api/recipients' # TODO: check on this

    # HTTP call details here
    config =
      method:   'GET'
      url:      _.template(url)(host: ApiConfig.host)
      data:     JSON.stringify _.extend({}, recipientID) # TODO
      headers:  
        'Content-Type': 'application/json'
        'X-Tranzit-Auth': TranzitAuthSession.user?.token

    # Send request and generate a promise
    return $http(config).then (data) ->
      return data.data.result

  return @
