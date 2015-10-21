'use strict'

angular.module('services.flashMessages', [])

.service 'flashMessages', ['$timeout', ($timeout) ->

  new class FlashMessages

    DEFAULT_TIMEOUT: 5000

    constructor: ->
      @messages = []

    isMessageObjValid: (messageObj) ->
      return false unless typeof messageObj.text is 'string'
      return false unless messageObj.type in ['info', 'alert', 'error', 'success']
      if messageObj.timeout?
        return false unless angular.isNumber messageObj.timeout
        return false unless parseInt(messageObj.timeout, 10) > 0
      true

    add: (messageObj) =>
      messageObj = angular.copy(messageObj)
      messageObj.timeout = messageObj.timeout or @DEFAULT_TIMEOUT
      throw "flashMessages service can't add message of invalid format" unless @isMessageObjValid messageObj
      messageId = UIDGenerator.generate()
      messageObj.id = messageId
      @messages.push messageObj
      $timeout =>
        @remove messageId
      , messageObj.timeout
      messageId

    addInfo: (title, text, timeout) =>
      messageObj = {title: title, text: text, timeout: timeout, type: 'info'}
      @add messageObj

    addAlert: (title, text, timeout) =>
      messageObj = {title: title, text: text, timeout: timeout, type: 'alert'}
      @add messageObj

    addError: (title, text, timeout) =>
      messageObj = {title: title, text: text, timeout: timeout, type: 'error'}
      @add messageObj

    addSuccess: (title, text, timeout) =>
      messageObj = {title: title, text: text, timeout: timeout, type: 'success'}
      @add messageObj

    remove: (messageId) =>
      for i in [0..@messages.length-1] # Using for instead of angular.forEach since forEach does not break on return
        if @messages[i].id is messageId
          return @messages.splice i, 1 # Returning here breaks the for loop intentionally

    removeAll: =>
      @messages = []

]
