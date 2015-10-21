describe 'localStorage service', ->
  localStorage = null

  beforeEach ->
    module 'services.localStorage'
    inject (_localStorage_) -> localStorage = _localStorage_
    window.localStorage.clear()

  describe 'constructor method', ->

    it 'should set available flag', ->
      expect(localStorage.isAvailable).toBeDefined()

  describe 'getItem method', ->

    it 'should get the value from the local storage', ->
      window.localStorage.setItem('test', 'passed')
      expect(localStorage.getItem('test')).toBe 'passed'

  describe 'setItem method', ->

    it 'should set the value to the local storage', ->
      localStorage.setItem('another_test', 'also_passed')
      expect(localStorage.getItem('another_test')).toBe 'also_passed'

  describe 'removeItem method', ->

    it 'should clear the key in the local storage', ->
      window.localStorage.setItem('remove_test', 'passed')
      localStorage.removeItem('remove_test')
      expect(localStorage.getItem('remove_test')).toBe null

  describe 'clear method', ->

    it 'should clear all items from the local storage', ->
      window.localStorage.setItem('first', 'key')
      window.localStorage.setItem('second', 'key')
      localStorage.clear()
      expect(localStorage.getItem('first')).toBe null
      expect(localStorage.getItem('second')).toBe null
