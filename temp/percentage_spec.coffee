describe 'percentage filter', ->

  percentage = null

  beforeEach module 'filters.percentage'
  beforeEach inject ($filter) ->
    percentage = $filter('percentage')

  it 'should return a string when provided a valid input', ->
    expect(typeof(percentage(0.5))).toBe 'string'
    expect(typeof(percentage(0.33333333, 3))).toBe 'string'

  it 'should return undefined when provided NaN', ->
    expect(percentage('NaN')).toBeUndefined()
    expect(percentage(true)).toBeUndefined()
    expect(percentage(new Date())).toBeUndefined()

  it 'should round percentage values to integers', ->
    expect(percentage(0.000001)).toBe '0%'
    expect(percentage(0.999999)).toBe '100%'

  it 'should convert numbers properly', ->
    expect(percentage(0.5)).toBe '50%'
    expect(percentage(1)).toBe '100%'
    expect(percentage(30)).toBe '3000%'

  it 'should use an precision parameter', ->
    expect(percentage(0, 0)).toBe '0%'
    expect(percentage(0.5, 0)).toBe '50%'
    expect(percentage(0.5, 1)).toBe '50.0%'
    expect(percentage(1, 3)).toBe '100.000%'
    expect(percentage(0.33333333, 3)).toBe '33.333%'
    expect(percentage(0.333, 3)).toBe '33.300%'
