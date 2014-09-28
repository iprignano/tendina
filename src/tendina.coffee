###
Tendina jQuery plugin v0.10.2

Copyright (c) 2014 Ivan Prignano
Released under the MIT License
###

(($, window) ->
  class Tendina

    # Default options
    defaults:
      animate:    true
      speed:      500
      onHover:    false
      hoverDelay: 200
      activeMenu: null

    constructor: (el, options) ->
      @options = $.extend({}, @defaults, options)
      @$el     = $(el)

      # Gets element selector - needed
      # for multiple menu initialization
      @elSelector = @_getSelector(@$el)

      # Adds tendina class to element
      # for better reference
      @$el.addClass('tendina')

      # Sets a class variable for anchor
      # elements that will be bound to the handler
      @linkSelector  = "#{@elSelector} a"
      @$listElements = $(@linkSelector).parent('li')

      # Hides submenus on document.ready
      @_hideSubmenus()

      # Set the event type (hover/click)
      @mouseEvent = if @options.onHover is true then 'mouseenter.tendina' else 'click.tendina'

      # Binds handler function
      # to interactive elements
      @_bindEvents()

      # Opens an active menu
      # if specified in the options
      @_openActiveMenu(@options.activeMenu) if @options.activeMenu isnt null

    # ==================
    # Private Methods
    # ==================
    _bindEvents: ->
      $(document).on @mouseEvent, @linkSelector, @_eventHandler

    _unbindEvents: ->
      $(document).off @mouseEvent

    _getSelector: (el) ->
      firstClass = $(el).attr('class')?.split(' ')[0]
      elId       = $(el).attr('id')

      if (elId isnt undefined) then "##{elId}" else ".#{firstClass}"

    _isFirstLevel: (targetEl) ->
      # Checks if target element
      # is a first level menu
      return true if $(targetEl).parent().parent().hasClass('tendina')

    _eventHandler: (event) =>
      targetEl = event.currentTarget

      # Opens or closes target menu
      if @_hasChildenAndIsHidden(targetEl)
        event.preventDefault()
        if @options.onHover
          setTimeout =>
            @_openSubmenu(targetEl) if $(targetEl).is(':hover')
          , @options.hoverDelay
        else
          @_openSubmenu(targetEl)
      else if @_isCurrentlyOpen(targetEl)
        event.preventDefault()
        @_closeSubmenu(targetEl) unless @options.onHover

    _openSubmenu: (el) ->
      $targetMenu  = $(el).next('ul')

      # Add selected class to menu
      $(el).parent('li').addClass('selected')

      # Closes all currently open menus
      # and opens the targeted one
      # TODO HERE
      @_open $targetMenu

      # After opening, fire callback
      @options.openCallback $(el).parent() if @options.openCallback

    _closeSubmenu: (el) ->
      $targetMenu  = $(el).next('ul')
      $nestedMenus = $targetMenu.find('li.selected')

      # Removes the selected class from the
      # menu that's being closed
      $(el)
        .parent()
        .removeClass('selected')

      # Closes the target menu
      @_close $targetMenu

      # Removes the selected class from
      # any open nested submenu and closes them
      $nestedMenus.removeClass('selected')
      @_close $nestedMenus.find('ul')

      # After closing, fire callback
      @options.closeCallback $(el).parent() if @options.closeCallback

    _open: ($el) ->
      if @options.animate
        $el.stop(true, true).slideDown(@options.speed)
      else
        $el.show()

    _close: ($el) ->
      if @options.animate
        $el.stop(true, true).slideUp(@options.speed)
      else
        $el.hide()

    _hasChildenAndIsHidden: (el) ->
      # Checks if there's a nested ul element
      # and, in that case, if it's currently hidden
      $(el).next('ul').length > 0 && $(el).next('ul').is(':hidden')

    _isCurrentlyOpen: (el) ->
      $(el).parent().hasClass 'selected'

    _hideSubmenus: ->
      @$el.find('ul').hide()

    _showSubmenus: ->
      @$el.find('ul').show()
      @$el.find('li').addClass 'selected'

    _openActiveMenu: (element) ->
      $activeMenu    = if element instanceof jQuery then element else @$el.find(element)
      $activeParents = $activeMenu.closest('ul').parents('li').find('> a')

      # Third and second level submenus
      if @_hasChildenAndIsHidden($activeParents)
        $activeParents.next('ul').show()
      # First level menu
      else
        $activeMenu.next('ul').show()

      # Adds selected class to opened menu
      # and all its parents
      $activeMenu.parent().addClass('selected')
      $activeParents.parent().addClass('selected')

    # ==================
    # API
    # ==================
    destroy: ->
      # Remove plugin instance
      @$el.removeData 'tendina'

      # Unbind events, remove namespace class
      # and show hidden submenus
      @_unbindEvents()
      @_showSubmenus()
      @$el.removeClass 'tendina'
      @$el.find('.selected').removeClass('selected')

    hideAll: ->
      @_hideSubmenus()

    showAll: ->
      @_showSubmenus()

  # ==================
  # jQuery Extend
  # ==================
  $.fn.extend tendina: (option, args...) ->
    @each ->
      $this = $(this)
      data  = $this.data('tendina')

      # Instances a new Tendina class
      # if not already done
      if !data
        $this.data 'tendina', (data = new Tendina(this, option))
      if typeof option == 'string'
        data[option].apply(data, args)

) window.jQuery, window
