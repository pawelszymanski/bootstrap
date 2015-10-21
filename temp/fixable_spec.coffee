describe 'fixable directive', ->

  fixableElem = null
  scope = null
  widget = null
  $document = null
  $timeout = null
  screenUtils = null

  beforeEach module 'directives.fixable'

  beforeEach inject ($rootScope, $compile, _$document_, _$timeout_, _screenUtils_) ->
    $document = _$document_
    $timeout = _$timeout_
    screenUtils = _screenUtils_

    scope = $rootScope.$new()
    fixableElem = $compile("<div fixable=''></div>")(scope)
    scope.$digest()
    widget = fixableElem.data 'fixable-directive-widget'

  describe 'throttle feature', ->

    it 'should be on when throttle param is greater than 0', ->
      widget.THROTTLE = 9
      spyOn widget, 'update'
      $document.triggerHandler 'scroll'
      expect(widget.update).not.toHaveBeenCalled()
      $timeout.flush()
      expect(widget.update).toHaveBeenCalled()

    it 'should be disabled when throttle param is set to 0', ->
      widget.THROTTLE = 0
      spyOn widget, 'update'
      $document.triggerHandler 'scroll'
      expect(widget.update).toHaveBeenCalled()

  # this test fails in PhantomJS therefore we don't run it there
  it "adds or removes a 'fixed' class after scrolling", ->
    unless navigator.userAgent.indexOf('PhantomJS') > -1
      widget.THROTTLE = 0
      bodyElem = angular.element(document.getElementsByTagName('body')[0])
      bodyElem.prepend fixableElem
      bodyElem.append angular.element '<div style="width: 10000px; height: 10000px;"></div>'
      expect(screenUtils.documentScrollTop()).toBe 0
      expect(fixableElem.hasClass('fixed')).toBe false
      screenUtils.documentScrollTop(1000)
      expect(screenUtils.documentScrollTop()).toBe 1000
      $document.triggerHandler 'scroll'
      expect(fixableElem.hasClass('fixed')).toBe true
      screenUtils.documentScrollTop(0)
      expect(screenUtils.documentScrollTop()).toBe 0
      $document.triggerHandler 'scroll'
      expect(fixableElem.hasClass('fixed')).toBe false
