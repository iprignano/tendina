(function() {
  var __slice = [].slice;

  (function($, window) {
    var Tendina;
    Tendina = (function() {
      function Tendina(el, options) {
        this.options = $.extend({}, this.defaults, options);
        $(el).addClass('tendina');
        this.firstLvlSubmenu = ".tendina > li";
        this.secondLvlSubmenu = ".tendina > li > ul > li";
        this.firstLvlSubmenuLink = "" + this.firstLvlSubmenu + " > a";
        this.secondLvlSubmenuLink = "" + this.secondLvlSubmenu + " > a";
        this.hideSubmenusOnStartup();
        this.bindEvents();
      }

      Tendina.prototype.bindEvents = function() {
        $(document).on('click', this.firstLvlSubmenuLink, (function(_this) {
          return function(event) {
            var clickedEl;
            clickedEl = event.currentTarget;
            if (_this.hasChildenAndIsHidden(clickedEl)) {
              event.preventDefault();
              return _this.openSubmenu(_this.firstLvlSubmenu, clickedEl);
            } else if (_this.isCurrentlyOpen(clickedEl)) {
              event.preventDefault();
              return _this.closeSubmenu(clickedEl);
            }
          };
        })(this));
        return $(document).on('click', this.secondLvlSubmenuLink, (function(_this) {
          return function(event) {
            var clickedEl;
            clickedEl = event.currentTarget;
            if (_this.hasChildenAndIsHidden(clickedEl)) {
              event.preventDefault();
              return _this.openSubmenu(_this.secondLvlSubmenu, clickedEl);
            } else if (_this.isCurrentlyOpen(clickedEl)) {
              event.preventDefault();
              return _this.closeSubmenu(clickedEl);
            }
          };
        })(this));
      };

      Tendina.prototype.openSubmenu = function(el, clickedEl) {
        $(el).removeClass('selected');
        $(el).find('> ul').slideUp();
        $(clickedEl).parent().addClass('selected');
        $(clickedEl).next('ul').slideDown();
        if (el === this.firstLvlSubmenu) {
          $(el).find('> ul > li').removeClass('selected');
          return $(el).find('> ul > li > ul').slideUp();
        }
      };

      Tendina.prototype.closeSubmenu = function(el) {
        $(el).parent().removeClass('selected');
        return $(el).next('ul').slideUp();
      };

      Tendina.prototype.hasChildenAndIsHidden = function(el) {
        return $(el).next('ul').length > 0 && $(el).next('ul').is(':hidden');
      };

      Tendina.prototype.isCurrentlyOpen = function(el) {
        return $(el).parent().hasClass('selected');
      };

      Tendina.prototype.hideSubmenusOnStartup = function() {
        $("" + this.firstLvlSubmenu + " > ul").hide();
        return $("" + this.secondLvlSubmenu + " > ul").hide();
      };

      return Tendina;

    })();
    return $.fn.extend({
      tendina: function() {
        var args, option;
        option = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        return this.each(function() {
          var $this, data;
          $this = $(this);
          data = $this.data('tendina');
          if (!data) {
            $this.data('tendina', (data = new Tendina(this, option)));
          }
          if (typeof option === 'string') {
            return data[option].apply(data, args);
          }
        });
      }
    });
  })(window.jQuery, window);

}).call(this);
