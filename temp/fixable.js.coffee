'use strict'

angular.module('directives.fixable', [
  'utils.screenUtils'
])

  .directive 'fixable', ['$document', '$timeout', 'screenUtils', ($document, $timeout, screenUtils) ->

    link: (scope, element) ->

      new class Fixable

        FIXED_CLASS: 'fixed'
        THROTTLE: 0

        constructor: ->
          element.data 'fixable-directive-widget', @

          @disabled = scope.fixableDisabled
          @timer = null
          @initialOffsetTop = element[0].offsetTop

          scope.$watch 'fixableDisabled', (newValue) =>
            @disabled = newValue
            @update()

          $document.on 'scroll', =>
            if @THROTTLE > 0
              $timeout.cancel(@timer)
              @timer = $timeout (=> @update()), @THROTTLE
            else
              @update()

        isElemShorterThanWindow: ->
          element[0].offsetHeight < screenUtils.windowHeight()

        scrolledBeyondInitialOffset: =>
          screenUtils.documentScrollTop() > @initialOffsetTop

        update: =>
          action = 'removeClass'
          action = 'addClass' if not @disabled and @scrolledBeyondInitialOffset() and @isElemShorterThanWindow()
          element[action] @FIXED_CLASS

  ]
