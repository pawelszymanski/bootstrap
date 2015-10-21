'use strict'

angular.module('constants.DECIMAL_SUFFIXES', [])
  .constant('DECIMAL_SUFFIXES',
    '0':  ''
    '3':  'K' # thousand
    '6':  'M' # million
    '9':  'B' # billion
    '12': 'T' # trillion
    '15': 'Q' # quadrillion
  )
