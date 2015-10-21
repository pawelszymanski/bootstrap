'use strict'

angular.module('services.localStorage', [])

.service 'localStorage', ['$window', ($window) ->

  new class LocalStorage

    constructor: ->
      @isAvailable = $window.localStorage?

    getItem: (key) =>
      $window.localStorage.getItem(key) if @isAvailable

    setItem: (key, value) =>
      $window.localStorage.setItem(key, value) if @isAvailable

    removeItem: (key) =>
      $window.localStorage.removeItem(key) if @isAvailable

    clear: =>
      $window.localStorage.clear() if @isAvailable

]
