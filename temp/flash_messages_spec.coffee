describe 'flashMessages directive', ->
  flashMessages = null
  elem = null
  scope = null

  beforeEach ->
    module 'templates'
    module 'directives.flashMessages'

    inject (_flashMessages_, $rootScope, $compile) ->
      flashMessages = _flashMessages_
      scope = $rootScope.$new()
      elem = $compile('<flash-messages></flash-messages>')(scope)
      scope.$digest()

  it 'should render template', ->
    expect(elem.find('div').hasClass('flash-messages-container')).toBe true

  it 'should have flashMessages service messages array bound to scope', ->
    expect(scope.messages.length).toBe 0
    flashMessages.add {type: 'info', text: 'text'}
    expect(scope.messages.length).toBe 1

  it 'should add valid Bootstrap classes to message elements', ->
    scope.$apply ->
      flashMessages.add {text: 'text', type: 'info'}
      flashMessages.add {text: 'text', type: 'alert'}
      flashMessages.add {text: 'text', type: 'error'}
      flashMessages.add {text: 'text', type: 'success'}
    messageDivs = elem.find('div')
    expect(messageDivs.eq(1).hasClass('alert-info')).toEqual true
    expect(messageDivs.eq(2).hasClass('alert-alert')).toEqual true
    expect(messageDivs.eq(3).hasClass('alert-danger')).toEqual true
    expect(messageDivs.eq(4).hasClass('alert-success')).toEqual true

  it 'should render proper amount of message div elements', ->
    scope.$apply ->
      flashMessages.add {type: 'info', text: 'text'}
    expect(elem.find('div').length).toBe 2

    lastId = null
    scope.$apply ->
      lastId = flashMessages.add {type: 'info', text: 'text'}
    expect(elem.find('div').length).toBe 3

    scope.$apply ->
      flashMessages.remove(lastId)
    expect(elem.find('div').length).toBe 2

  it 'should contain message.title and message.text', ->
    scope.$apply ->
      flashMessages.add {type: 'info', title: 'anUniqueTitle', text: 'anUniqueText'}
    expect(elem.text().indexOf('anUniqueTitle')).toBeGreaterThan -1
    expect(elem.text().indexOf('anUniqueText')).toBeGreaterThan -1

  it 'should call flashMessages service to remove one of messages', ->
    messageId = null
    scope.$apply ->
      messageId = flashMessages.add {type: 'info', text: 'text'}
    spy = spyOn flashMessages, 'remove'
    elem.find('button').triggerHandler('click')
    expect(spy).toHaveBeenCalledWith(messageId)

  it "should delete a message when clicking on the 'x' button", ->
    scope.$apply ->
      flashMessages.add {type: 'info', text: 'text'}
    expect(elem.find('div').length).toBe 2
    expect(elem.find('button').length).toBe 1
    elem.find('button').triggerHandler('click')
    expect(elem.find('div').length).toBe 1
