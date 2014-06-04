###
Tendina jQuery plugin v0.8.1

Copyright (c) 2014 Ivan Prignano
Released under the MIT License
###

(($, window) ->
  class Tendina

    # Default options
    defaults:
      animate: true
      speed: 500

    constructor: (el, options) ->
      @options = $.extend({}, @defaults, options)
      @$el     = $(el)

      # Checks if options object
      # contains wrong values
      @_checkOptions()

      # Adds tendina class to element
      # for better reference
      @$el.addClass('tendina')

      # Sets class vars for relevant elements
      @firstLvlSubmenu      = ".tendina > li"
      @secondLvlSubmenu     = ".tendina > li > ul > li"
      @firstLvlSubmenuLink  = "#{@firstLvlSubmenu} > a"
      @secondLvlSubmenuLink = "#{@secondLvlSubmenu} > a"

      # Hides submenus on document.ready
      @_hideSubmenus()

      # Binds handler functions
      # to clickable elements
      @_bindEvents()

    # Private Methods
    _bindEvents: ->
      $(document).on 'click.tendina', "#{@firstLvlSubmenuLink}, #{@secondLvlSubmenuLink}", @_clickHandler

    _unbindEvents: ->
      $(document).off 'click.tendina'

    _isFirstLevel: (clickedEl) ->
      # Checks if clicked element
      # is a first level menu
      return true if $(clickedEl).parent().parent().hasClass('tendina')

    _clickHandler: (event) =>
      clickedEl    = event.currentTarget
      submenuLevel = if @_isFirstLevel(clickedEl) then @firstLvlSubmenu else @secondLvlSubmenu

      # Opens or closes clicked menu
      if @_hasChildenAndIsHidden(clickedEl)
        event.preventDefault()
        @_openSubmenu(submenuLevel, clickedEl)
      else if @_isCurrentlyOpen(clickedEl)
        event.preventDefault()
        @_closeSubmenu(clickedEl)

    _openSubmenu: (el, clickedEl) ->
      $firstNestedMenu   = $(el).find('> ul')
      $lastNestedMenu    = $(el).find('> ul > li > ul')
      $clickedNestedMenu = $(clickedEl).next('ul')

      # Removes selected class from all the current
      # level menus and adds it to clicked menu
      $(el).removeClass 'selected'
      $(clickedEl).parent().addClass 'selected'

      # Closes all currently open menus
      # and opens the clicked one
      @_close($firstNestedMenu)
      @_open($clickedNestedMenu)

      # If clicked element is a first-level
      # menu, closes all opened second-level submenus
      if el is @firstLvlSubmenu
        $(el).find('> ul > li').removeClass 'selected'
        @_close($lastNestedMenu)

      # After opening, fire callback
      @options.openCallback $(clickedEl).parent() if @options.openCallback

    _closeSubmenu: (el) ->
      $clickedNestedMenu = $(el).next('ul')

      # Removes the selected class from the
      # menu that's being closed
      $(el).parent().removeClass 'selected'
      @_close($clickedNestedMenu)

      # After closing, fire callback
      @options.closeCallback $(el).parent() if @options.closeCallback

    _open: ($el) ->
      if @options.animate
        $el.slideDown(@options.speed)
      else
        $el.show()

    _close: ($el) ->
      if @options.animate
        $el.slideUp(@options.speed)
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

    _checkOptions: ->
      if @options.animate isnt true or false
        console.warn "jQuery.fn.Tendina - '#{@options.animate}' is not a valid parameter for the 'animate' option. Falling back to default value."
      if @options.speed isnt parseInt(@options.speed)
        console.warn "jQuery.fn.Tendina - '#{@options.speed}' is not a valid parameter for the 'speed' option. Falling back to default value."

    # API
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

  # Extends jQuery with the tendina method
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