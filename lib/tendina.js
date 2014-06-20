
/*
Tendina jQuery plugin v0.8.1

Copyright (c) 2014 Ivan Prignano
Released under the MIT License
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __slice = [].slice;

  (function($, window) {
    var Tendina;
    Tendina = (function() {
      Tendina.prototype.defaults = {
        animate: true,
        speed: 500,
        onHover: false,
        hoverDelay: 200
      };

      function Tendina(el, options) {
        this._eventHandler = __bind(this._eventHandler, this);
        this.options = $.extend({}, this.defaults, options);
        this.$el = $(el);
        this._checkOptions();
        this.$el.addClass('tendina');
        this.firstLvlSubmenu = ".tendina > li";
        this.secondLvlSubmenu = ".tendina > li > ul > li";
        this.firstLvlSubmenuLink = "" + this.firstLvlSubmenu + " > a";
        this.secondLvlSubmenuLink = "" + this.secondLvlSubmenu + " > a";
        this._hideSubmenus();
        this.mouseEvent = this.options.onHover === true ? 'mouseenter.tendina' : 'click.tendina';
        this._bindEvents();
      }

      Tendina.prototype._bindEvents = function() {
        return $(document).on(this.mouseEvent, "" + this.firstLvlSubmenuLink + ", " + this.secondLvlSubmenuLink, this._eventHandler);
      };

      Tendina.prototype._unbindEvents = function() {
        return $(document).off(this.mouseEvent);
      };

      Tendina.prototype._isFirstLevel = function(targetEl) {
        if ($(targetEl).parent().parent().hasClass('tendina')) {
          return true;
        }
      };

      Tendina.prototype._eventHandler = function(event) {
        var submenuLevel, targetEl;
        targetEl = event.currentTarget;
        submenuLevel = this._isFirstLevel(targetEl) ? this.firstLvlSubmenu : this.secondLvlSubmenu;
        if (this._hasChildenAndIsHidden(targetEl)) {
          event.preventDefault();
          if (this.options.onHover) {
            return setTimeout((function(_this) {
              return function() {
                if ($(targetEl).is(':hover')) {
                  return _this._openSubmenu(submenuLevel, targetEl);
                }
              };
            })(this), this.options.hoverDelay);
          } else {
            return this._openSubmenu(submenuLevel, targetEl);
          }
        } else if (this._isCurrentlyOpen(targetEl)) {
          event.preventDefault();
          if (!this.options.onHover) {
            return this._closeSubmenu(targetEl);
          }
        }
      };

      Tendina.prototype._openSubmenu = function(el, targetEl) {
        var $firstNestedMenu, $lastNestedMenu, $targetNestedMenu;
        $firstNestedMenu = $(el).find('> ul');
        $lastNestedMenu = $(el).find('> ul > li > ul');
        $targetNestedMenu = $(targetEl).next('ul');
        $(el).removeClass('selected');
        $(targetEl).parent().addClass('selected');
        this._close($firstNestedMenu);
        this._open($targetNestedMenu);
        if (el === this.firstLvlSubmenu) {
          $(el).find('> ul > li').removeClass('selected');
          this._close($lastNestedMenu);
        }
        if (this.options.openCallback) {
          return this.options.openCallback($(targetEl).parent());
        }
      };

      Tendina.prototype._closeSubmenu = function(el) {
        var $targetNestedMenu;
        $targetNestedMenu = $(el).next('ul');
        $(el).parent().removeClass('selected');
        this._close($targetNestedMenu);
        if (this.options.closeCallback) {
          return this.options.closeCallback($(el).parent());
        }
      };

      Tendina.prototype._open = function($el) {
        if (this.options.animate) {
          return $el.stop(true).slideDown(this.options.speed);
        } else {
          return $el.show();
        }
      };

      Tendina.prototype._close = function($el) {
        if (this.options.animate) {
          return $el.stop(true).slideUp(this.options.speed);
        } else {
          return $el.hide();
        }
      };

      Tendina.prototype._hasChildenAndIsHidden = function(el) {
        return $(el).next('ul').length > 0 && $(el).next('ul').is(':hidden');
      };

      Tendina.prototype._isCurrentlyOpen = function(el) {
        return $(el).parent().hasClass('selected');
      };

      Tendina.prototype._hideSubmenus = function() {
        $("" + this.firstLvlSubmenu + " > ul, " + this.secondLvlSubmenu + " > ul").hide();
        return $("" + this.firstLvlSubmenu + " > ul").removeClass('selected');
      };

      Tendina.prototype._showSubmenus = function() {
        $("" + this.firstLvlSubmenu + " > ul, " + this.secondLvlSubmenu + " > ul").show();
        return $("" + this.firstLvlSubmenu).removeClass('selected');
      };

      Tendina.prototype._checkOptions = function() {
        if (this.options.animate !== true || false) {
          console.warn("jQuery.fn.Tendina - '" + this.options.animate + "' is not a valid parameter for the 'animate' option. Falling back to default value.");
        }
        if (this.options.speed !== parseInt(this.options.speed)) {
          console.warn("jQuery.fn.Tendina - '" + this.options.speed + "' is not a valid parameter for the 'speed' option. Falling back to default value.");
        }
        if (this.options.onHover !== true || false) {
          return console.warn("jQuery.fn.Tendina - '" + this.options.onHover + "' is not a valid parameter for the 'onHover' option. Falling back to default value.");
        }
      };

      Tendina.prototype.destroy = function() {
        this.$el.removeData('tendina');
        this._unbindEvents();
        this._showSubmenus();
        this.$el.removeClass('tendina');
        return this.$el.find('.selected').removeClass('selected');
      };

      Tendina.prototype.hideAll = function() {
        return this._hideSubmenus();
      };

      Tendina.prototype.showAll = function() {
        return this._showSubmenus();
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
