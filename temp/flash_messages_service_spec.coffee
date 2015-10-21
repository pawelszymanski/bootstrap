describe 'flashMessages service', ->
  flashMessages = null

  beforeEach ->
    module 'services.flashMessages'
    inject (_flashMessages_) -> flashMessages = _flashMessages_

  describe 'isMessageObjValid method', ->

    it 'should return false if messageObj does not have required properties', ->
      expect(flashMessages.isMessageObjValid({type: 'type'})).toEqual false # does not have text
      expect(flashMessages.isMessageObjValid({text: 'text'})).toEqual false # does not have type

    it "should return false if messageObjects's type is not in set of predefined types", ->
      expect(flashMessages.isMessageObjValid({text: 'text', timeout: 123, type: 'wrong-type'})).toEqual false

    it "should return true if messageObjects's type is in set of predefined types", ->
      expect(flashMessages.isMessageObjValid({text: 'text', timeout: 123, type: 'info'})).toEqual true
      expect(flashMessages.isMessageObjValid({text: 'text', timeout: 123, type: 'alert'})).toEqual true
      expect(flashMessages.isMessageObjValid({text: 'text', timeout: 123, type: 'error'})).toEqual true
      expect(flashMessages.isMessageObjValid({text: 'text', timeout: 123, type: 'success'})).toEqual true

    it 'should return false if messageObj.timeout is not positive integer/float', ->
      expect(flashMessages.isMessageObjValid({type: 'info', text: 'text', timeout: -9})).toBe false       # < 0
      expect(flashMessages.isMessageObjValid({type: 'info', text: 'text', timeout: 0})).toBe false        # = 0
      expect(flashMessages.isMessageObjValid({type: 'info', text: 'text', timeout: 'string'})).toBe false # String
      expect(flashMessages.isMessageObjValid({type: 'info', text: 'text', timeout: {}})).toBe false       # Object
      expect(flashMessages.isMessageObjValid({type: 'info', text: 'text', timeout: []})).toBe false       # Array

  describe 'add method', ->

    it 'should add a default message timeout if timeout key is missing', ->
      flashMessages.add {type: 'info', text: 'text'}
      expect(flashMessages.messages.pop().timeout).toBeDefined()

    it 'should return a string with id of added message', ->
      expect(typeof(flashMessages.add({type: 'info', text: 'text'}))).toBe 'string'

    it 'should add one element to @messages array when called with valid message object', ->
      beforeLength = flashMessages.messages.length
      flashMessages.add {type: 'info', text: 'text'}
      afterLength = flashMessages.messages.length
      expect(afterLength - beforeLength).toBe 1

    it 'should call remove method with messageId as a parameter', inject ($timeout) ->
      spyOn flashMessages, 'remove'
      messageId = flashMessages.add {type: 'info', text: 'text'}
      $timeout.flush()
      expect(flashMessages.remove).toHaveBeenCalledWith messageId

    it 'should throw when called with invalid messageobject', ->
      expect( -> flashMessages.add('not valid message object')).toThrow()

  describe 'helper methods', ->

    for helperName in ['info', 'alert', 'error', 'success']
      methodName = 'add' + helperName.charAt(0).toUpperCase() + helperName.slice(1) # addInfo, addAlert, addError, addSuccess

      it 'should call add method', ->
        spy = spyOn flashMessages, 'add'
        flashMessages[methodName] 'title', 'text'
        expect(spy).toHaveBeenCalledWith {title: 'title', text: 'text', timeout: undefined, type: helperName}
        flashMessages[methodName] 'title', 'text', 1234
        expect(spy).toHaveBeenCalledWith {title: 'title', text: 'text', timeout: 1234, type: helperName}

      it 'should return a string with id of added message', ->
        result = flashMessages[methodName] 'title', 'text', 1234
        expect(angular.isString(result)).toEqual true

  describe 'remove method', ->

    it 'should not remove anything from @messages array if @messages do not cointain particular message id', ->
      flashMessages.messages = [{id: 'firstId'}, {id: 'secondId'}]
      flashMessages.remove 'other'
      expect(flashMessages.messages.length).toBe 2

    it 'should remove entry from @messages array if @messages do cointain particular message id', ->
      flashMessages.messages = [{id: 'firstId'}, {id: 'secondId'}, {id: 'thirdId'}]
      flashMessages.remove 'firstId'
      flashMessages.remove 'thirdId'
      expect(flashMessages.messages.length).toBe 1
      expect(flashMessages.messages[0].id).toBe 'secondId'

  describe 'removeAll method', ->

    it 'should remove all messages', ->
      flashMessages.messages = [{id: 'firstId'}, {id: 'secondId'}]
      flashMessages.removeAll()
      expect(flashMessages.messages.length).toBe 0
