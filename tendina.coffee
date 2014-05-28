(($, window) ->
  class Tendina

    defaults:
      animate: true
      speed: 500

    constructor: (el, options) ->
      @options = $.extend({}, @defaults, options)

      $(el).addClass('tendina')

      @firstLvlSubmenu      = ".tendina > li"
      @secondLvlSubmenu     = ".tendina > li > ul > li"
      @firstLvlSubmenuLink  = "#{@firstLvlSubmenu} > a"
      @secondLvlSubmenuLink = "#{@secondLvlSubmenu} > a"

      @hideSubmenusOnStartup()
      @bindEvents()

    bindEvents: ->
      $(document).on 'click', "#{@firstLvlSubmenuLink}, #{@secondLvlSubmenuLink}", @clickHandler

    isFirstLevel: (clickedEl) ->
      return true if $(clickedEl).parent().parent().hasClass('tendina')

    clickHandler: (event) =>
      clickedEl    = event.currentTarget
      submenuLevel = if @isFirstLevel(clickedEl) then @firstLvlSubmenu else @secondLvlSubmenu

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

      $(el).removeClass 'selected'
      $(clickedEl).parent().addClass 'selected'

      @close($firstNestedMenu)
      @open($clickedNestedMenu)

      if el is @firstLvlSubmenu
        $(el).find('> ul > li').removeClass 'selected'
        @close($lastNestedMenu)

    closeSubmenu: (el) ->
      $clickedNestedMenu = $(el).next('ul')

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
      $(el).next('ul').length > 0 && $(el).next('ul').is ':hidden'

    isCurrentlyOpen: (el) ->
      $(el).parent().hasClass 'selected'

    hideSubmenusOnStartup: ->
      $("#{@firstLvlSubmenu} > ul").hide()
      $("#{@secondLvlSubmenu} > ul").hide()

  $.fn.extend tendina: (option, args...) ->
    @each ->
      $this = $(this)
      data = $this.data('tendina')

      if !data
        $this.data 'tendina', (data = new Tendina(this, option))
      if typeof option == 'string'
        data[option].apply(data, args)

) window.jQuery, window