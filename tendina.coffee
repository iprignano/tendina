###
Tendina jQuery plugin v0.1.2

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

      # Checks if options object
      # contains wrong values
      @checkOptions()

      # Adds tendina class to element
      # for better reference
      $(el).addClass('tendina')

      # Sets class vars for relevant elements
      @firstLvlSubmenu      = ".tendina > li"
      @secondLvlSubmenu     = ".tendina > li > ul > li"
      @firstLvlSubmenuLink  = "#{@firstLvlSubmenu} > a"
      @secondLvlSubmenuLink = "#{@secondLvlSubmenu} > a"

      # Hides submenus on document.ready
      @hideSubmenusOnStartup()

      # Binds handler functions
      # to clickable elements
      @bindEvents()

    bindEvents: ->
      $(document).on 'click', "#{@firstLvlSubmenuLink}, #{@secondLvlSubmenuLink}", @clickHandler

    isFirstLevel: (clickedEl) ->
      # Checks if clicked element
      # is a first level menu
      return true if $(clickedEl).parent().parent().hasClass('tendina')

    clickHandler: (event) =>
      clickedEl    = event.currentTarget
      submenuLevel = if @isFirstLevel(clickedEl) then @firstLvlSubmenu else @secondLvlSubmenu

      # Opens or closes clicked menu
      if @hasChildenAndIsHidden(clickedEl)
        event.preventDefault()
        @openSubmenu(submenuLevel, clickedEl)
      else if @isCurrentlyOpen(clickedEl)
        event.preventDefault()
        @closeSubmenu(clickedEl)

    openSubmenu: (el, clickedEl) ->
      $firstNestedMenu   = $(el).find('> ul')
      $lastNestedMenu    = $(el).find('> ul > li > ul')
      $clickedNestedMenu = $(clickedEl).next('ul')

      # Removes selected class from all the current
      # level menus and adds it to clicked menu
      $(el).removeClass 'selected'
      $(clickedEl).parent().addClass 'selected'

      # Closes all currently open menus
      # and opens the clicked one
      @close($firstNestedMenu)
      @open($clickedNestedMenu)

      # If clicked element is a first-level
      # menu, closes all opened second-level submenus
      if el is @firstLvlSubmenu
        $(el).find('> ul > li').removeClass 'selected'
        @close($lastNestedMenu)

    closeSubmenu: (el) ->
      $clickedNestedMenu = $(el).next('ul')

      # Removes the selected class from the
      # menu that's being closed
      $(el).parent().removeClass 'selected'
      @close($clickedNestedMenu)

    open: ($el) ->
      if @options.animate
        $el.slideDown(@options.speed)
      else
        $el.show()

    close: ($el) ->
      if @options.animate
        $el.slideUp(@options.speed)
      else
        $el.hide()

    hasChildenAndIsHidden: (el) ->
      # Checks if there's a nested ul element
      # and, in that case, if it's currently hidden
      $(el).next('ul').length > 0 && $(el).next('ul').is(':hidden')

    isCurrentlyOpen: (el) ->
      $(el).parent().hasClass 'selected'

    hideSubmenusOnStartup: ->
      $("#{@firstLvlSubmenu} > ul, #{@secondLvlSubmenu} > ul").hide()

    checkOptions: ->
      if @options.animate isnt true or false
        console.warn "jQuery.fn.Tendina - '#{@options.animate}' is not a valid parameter for the 'animate' option. Falling back to default value."
      if @options.speed isnt parseInt(@options.speed)
        console.warn "jQuery.fn.Tendina - '#{@options.speed}' is not a valid parameter for the 'speed' option. Falling back to default value."

  # Extends jQuery with the tendina method
  $.fn.extend tendina: (option, args...) ->
    @each ->
      $this = $(this)
      data = $this.data('tendina')

      # Instances a new Tendina class
      # if not already done
      if !data
        $this.data 'tendina', (data = new Tendina(this, option))

) window.jQuery, window