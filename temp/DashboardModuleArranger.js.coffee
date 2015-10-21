class DashboardModuleArranger

  isToBeDragged: (event) =>
    result = false
    if $(event.target).add($(event.target).parents()).filter(".#{@DRAGGABLE_CLASS}").length > 0
      unless $(event.target).hasClass("#{@NO_DRAG_CLASS}")
        if event.which is 1    # left mouse button
          result = true
    return result

  cloneModule: =>
    @clonedElem = @originalElem.clone()
    @originalElem.addClass("#{@GHOST_CLASS}")
    @clonedElem.addClass("#{@DRAGGED_CLASS}")
    @clonedElem.css
      width: @originalElem.outerWidth()
      position: 'absolute'
      'z-index': 1
    $('body').prepend(@clonedElem)

  horizontalCenterOfDraggedModule: =>
    @clonedElem.offset().left + (@clonedElem.outerWidth() / 2)

  columnOfOriginal: =>
    if @originalElem.parents('.column').hasClass('left') then 'left' else 'right'

  columnOfOriginalAsElem: =>
    if @originalElem.parents('.column').hasClass('left') then @leftColumn else @rightColumn

  columnOfClone: =>
    switch @columnOfOriginal()
      when 'left'
        if @horizontalCenterOfDraggedModule() > @rightColumn.offset().left then return 'right' else return 'left'
      when 'right'
        if @horizontalCenterOfDraggedModule() < (@leftColumn.offset().left + @leftColumn.outerWidth()) then return 'left' else return 'right'

  oppositeColumnElem: =>
    if @columnOfOriginal() is 'left' then @rightColumn else @leftColumn

  prevSiblingTopOffset: =>
    if @originalElem.prev('.module').length is 0 then return undefined else return @originalElem.prev('.module').first().offset().top

  nextSiblingTopOffset: =>
    if @originalElem.next('.module').length is 0 then return undefined else return @originalElem.next('.module').first().offset().top

  updateDrag: (event) =>
    @clonedElem.css
      left: @moduleStartPos.x + event.pageX - @dragStartPos.x + 1
      top:  @moduleStartPos.y + event.pageY - @dragStartPos.y + 1
    unless @columnOfClone() is @columnOfOriginal()
      @oppositeColumnElem().prepend @originalElem
    while (@prevSiblingTopOffset()?) and (event.pageY < @prevSiblingTopOffset())
      @originalElem.insertBefore(@originalElem.prev('.module'))
    while (@nextSiblingTopOffset()?) and (event.pageY > @nextSiblingTopOffset())
      @originalElem.insertAfter(@originalElem.next('.module'))

  finalizeDrag: =>
    $(document).unbind('mousemove.module_drag')
    $(document).unbind('mouseup.module_drag')
    @clonedElem.remove()
    @originalElem.removeClass("#{@GHOST_CLASS}")

  startDrag: (element, event) =>
    event.preventDefault()    # prevents text drag when text is selected
    @originalElem = element
    @cloneModule()
    @moduleStartPos =
      x : @originalElem.offset().left
      y : @originalElem.offset().top
    @dragStartPos =
      x : event.pageX
      y : event.pageY
    @updateDrag(event)
    $(document).on 'mousemove.module_drag', (event) =>
      @updateDrag(event)
    $(document).on 'mouseup.module_drag', (event) =>
      @finalizeDrag()

  constructor: ->
    @modules = $('.main_panel#dashboard .module')
    @leftColumn = $('.main_panel#dashboard .column.left')
    @rightColumn = $('.main_panel#dashboard .column.right')

    @DRAGGABLE_CLASS = 'draggable'
    @DRAGGED_CLASS = 'dragged'
    @NO_DRAG_CLASS = 'icon'
    @GHOST_CLASS = 'ghost'

    @modules.on 'mousedown', (event) =>
      @startDrag($(event.target).parents('.module'), event)  if @isToBeDragged(event)



$ ->

  new DashboardModuleArranger  if $('.main_panel#dashboard').length > 0


