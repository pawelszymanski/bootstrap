'use strict'

angular.module('filters.percentage', [])

  .filter 'percentage', [ ->

    (floatOrString, precision = 0) ->

      float = parseFloat floatOrString
      return if isNaN float
      ((float * Math.pow(10, 2 + precision)) / Math.pow(10, precision)).toFixed(precision) + '%'

  ]
