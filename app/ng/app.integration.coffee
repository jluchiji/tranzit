#   ______   ______     ______     __   __     ______     __     ______
#  /\__  _\ /\  == \   /\  __ \   /\ "-.\ \   /\___  \   /\ \   /\__  _\
#  \/_/\ \/ \ \  __<   \ \  __ \  \ \ \-.  \  \/_/  /__  \ \ \  \/_/\ \/
#     \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_\\"\_\   /\_____\  \ \_\    \ \_\
#      \/_/   \/_/ /_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/     \/_/
#
# Copyright © 2015 Tranzit Development Team
angular.module 'Tranzit.app.integration', []
.service 'AppIntegration', ($state, $q) ->

  # Fake 3rd party API integration.
  # In this particular case, we shall pull from hard-coded JSON.
  # We also add random delays to simulate network lag.

  random = (min, max) -> Math.floor(Math.random() * (max - min)) + min

  options =
    lag:
      min: 300
      max: 3000

  data =
    '1Z6089649053538738':
      name: 'Greg Clark'
      address: '1885 Hummingbird Way, Winchester, MA'

  self = { }

  self.getInfo = (tracking) ->
    deferred = $q.defer()
    setTimeout (->
      if data[tracking]
        deferred.resolve(data[tracking])
      else
        deferred.reject('Package not found.')
      ), random(options.lag.min, options.lag.max)
    return deferred.promise

  return self
