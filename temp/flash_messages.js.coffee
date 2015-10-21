'use strict'

angular.module('directives.flashMessages', [
  'services.flashMessages'
])

  .directive 'flashMessages', [ ->

    restrict: 'E'
    replace: true
    templateUrl: '/templates/directives/flash_messages.html'

    controller: ['$scope', 'flashMessages', ($scope, flashMessages) ->

      $scope.messages = flashMessages.messages

      $scope.typeToClass = (type) ->
        switch type
          when 'error' then 'alert-danger' # Error message has class of 'danger' in Bootstrap
          else 'alert-' + type             # The remaining ('info', 'alert' and 'success') match Bootstrap classes

      $scope.remove = (messageId) ->
        flashMessages.remove messageId

    ]

  ]
