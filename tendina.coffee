(($, window) ->
  class Tendina
    constructor: (el, options) ->
      @options = $.extend({}, @defaults, options)
      @menuElement          = $(el).attr('class')
      @firstLvlSubmenu      = ".#{@menuElement} > li"
      @secondLvlSubmenu     = ".#{@menuElement} > li > ul > li"
      @firstLvlSubmenuLink  = "#{@firstLvlSubmenu} > a"
      @secondLvlSubmenuLink = "#{@secondLvlSubmenu} > a"

      @hideSubmenus()
      @bindEvents()

    bindEvents: ->
      $(document).on 'click', @firstLvlSubmenuLink, (event) =>
        clickedEl = event.currentTarget

        if @hasChildenAndIsHidden(clickedEl)
          event.preventDefault()
          @openSubmenu(@firstLvlSubmenu, clickedEl)
        else if @isCurrentlyOpen(clickedEl)
          event.preventDefault()
          @closeSubmenu(clickedEl)

      $(document).on 'click', @secondLvlSubmenuLink, (event) =>
        clickedEl = event.currentTarget

        if @hasChildenAndIsHidden(clickedEl)
          event.preventDefault()
          @openSubmenu(@secondLvlSubmenu, clickedEl)
        else if @isCurrentlyOpen(clickedEl)
          event.preventDefault()
          @closeSubmenu(clickedEl)

    openSubmenu: (el, clickedEl) ->
      $(el).removeClass 'selected'
      $(el).find('> ul').slideUp()
      $(clickedEl).parent().addClass 'selected'
      $(clickedEl).next('ul').slideDown()

      if el is @firstLvlSubmenu
        $(el).find('> ul > li').removeClass 'selected'
        $(el).find('> ul > li > ul').slideUp()

    closeSubmenu: (el) ->
      $(el).parent().removeClass 'selected'
      $(el).next('ul').slideUp()

    hasChildenAndIsHidden: (el) ->
      $(el).next('ul').length > 0 && $(el).next('ul').is ':hidden'

    isCurrentlyOpen: (el) ->
      $(el).parent().hasClass 'selected'

    hideSubmenus: ->
      $(".#{@menuElement} > li > ul").hide()
 
  $.fn.extend tendina: (option, args...) ->
    @each ->
      $this = $(this)
      data = $this.data('tendina')
 
      if !data
        $this.data 'tendina', (data = new Tendina(this, option))
      if typeof option == 'string'
        data[option].apply(data, args)
 
) window.jQuery, window