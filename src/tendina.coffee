###
Tendina jQuery plugin v0.10.0

Copyright (c) 2014 Ivan Prignano
Released under the MIT License
###

(($, window) ->
  class Tendina

    # Default options
    defaults:
      animate: true
      speed: 500
      onHover: false
      hoverDelay: 200
      activeMenu: null

    constructor: (el, options) ->
      @options = $.extend({}, @defaults, options)
      @$el     = $(el)

      # Checks if options object
      # contains wrong values
      @_checkOptions()

      # Gets element selector - needed
      # for multiple menu initialization
      @elSelector = @_getSelector(@$el)

      # Adds tendina class to element
      # for better reference
      @$el.addClass('tendina')

      # Sets class variables for relevant elements.
      # I'm doing this instead of wrapping every element
      # in a jQuery object in order to correctly
      # bind events to dynamically added elements
      @firstLvlSubmenu      = "#{@elSelector} > li"
      @secondLvlSubmenu     = "#{@elSelector} > li > ul > li"
      @firstLvlSubmenuLink  = "#{@firstLvlSubmenu} > a"
      @secondLvlSubmenuLink = "#{@secondLvlSubmenu} > a"

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
      $(document).on @mouseEvent, "#{@firstLvlSubmenuLink}, #{@secondLvlSubmenuLink}", @_eventHandler

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
      targetEl     = event.currentTarget
      submenuLevel = if @_isFirstLevel(targetEl) then @firstLvlSubmenu else @secondLvlSubmenu

      # Opens or closes target menu
      if @_hasChildenAndIsHidden(targetEl)
        event.preventDefault()
        if @options.onHover
          setTimeout =>
            @_openSubmenu(submenuLevel, targetEl) if $(targetEl).is(':hover')
          , @options.hoverDelay
        else
          @_openSubmenu(submenuLevel, targetEl)
      else if @_isCurrentlyOpen(targetEl)
        event.preventDefault()
        @_closeSubmenu(targetEl) unless @options.onHover

    _openSubmenu: (el, targetEl) ->
      $firstNestedMenu  = $(el).find('> ul')
      $lastNestedMenu   = $(el).find('> ul > li > ul')
      $targetNestedMenu = $(targetEl).next('ul')

      # Removes selected class from all the current
      # level menus and adds it to target menu
      $(el).removeClass 'selected'
      $(targetEl).parent().addClass 'selected'

      # Closes all currently open menus
      # and opens the targeted one
      @_close($firstNestedMenu)
      @_open($targetNestedMenu)

      # If target element is a first-level
      # menu, closes all opened second-level submenus
      if el is @firstLvlSubmenu
        $(el).find('> ul > li').removeClass 'selected'
        @_close($lastNestedMenu)

      # After opening, fire callback
      @options.openCallback $(targetEl).parent() if @options.openCallback

    _closeSubmenu: (el) ->
      $targetNestedMenu = $(el).next('ul')
      $targetNestedOpenSubmenu = $targetNestedMenu.find('> li.selected')

      # Removes the selected class from the
      # menu that's being closed
      $(el).parent().removeClass 'selected'
      @_close($targetNestedMenu)

      # Removes the selected class from
      # any open nested submenu and closes it
      $targetNestedOpenSubmenu.removeClass 'selected'
      @_close($targetNestedOpenSubmenu.find('> ul'))

      # After closing, fire callback
      @options.closeCallback $(el).parent() if @options.closeCallback

    _open: ($el) ->
      if @options.animate
        $el.stop(true).slideDown(@options.speed)
      else
        $el.show()

    _close: ($el) ->
      if @options.animate
        $el.stop(true).slideUp(@options.speed)
      else
        $el.hide()

    _hasChildenAndIsHidden: (el) ->
      # Checks if there's a nested ul element
      # and, in that case, if it's currently hidden
      $(el).next('ul').length > 0 && $(el).next('ul').is(':hidden')

    _isCurrentlyOpen: (el) ->
      $(el).parent().hasClass 'selected'

    _hideSubmenus: ->
      $("#{@firstLvlSubmenu} > ul, #{@secondLvlSubmenu} > ul").hide()
      $("#{@firstLvlSubmenu} > ul").removeClass 'selected'

    _showSubmenus: ->
      $("#{@firstLvlSubmenu} > ul, #{@secondLvlSubmenu} > ul").show()
      $("#{@firstLvlSubmenu}").removeClass 'selected'

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
      $activeMenu.parent().addClass 'selected'
      $activeParents.parent().addClass 'selected'

    _checkOptions: ->
      if @options.animate isnt true and @options.animate isnt false
        console.warn "jQuery.fn.Tendina - '#{@options.animate}' is not a valid parameter for the 'animate' option. Falling back to default value."
      if @options.speed   isnt parseInt(@options.speed)
        console.warn "jQuery.fn.Tendina - '#{@options.speed}' is not a valid parameter for the 'speed' option. Falling back to default value."
      if @options.onHover isnt true and @options.onHover isnt false
        console.warn "jQuery.fn.Tendina - '#{@options.onHover}' is not a valid parameter for the 'onHover' option. Falling back to default value."

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