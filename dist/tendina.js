
/*
Tendina jQuery plugin v0.10.2

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
        hoverDelay: 200,
        activeMenu: null
      };

      function Tendina(el, options) {
        this._eventHandler = __bind(this._eventHandler, this);
        this.options = $.extend({}, this.defaults, options);
        this.$el = $(el);
        this._checkOptions();
        this.elSelector = this._getSelector(this.$el);
        this.$el.addClass('tendina');
        this.firstLvlSubmenu = "" + this.elSelector + " > li";
        this.secondLvlSubmenu = "" + this.elSelector + " > li > ul > li";
        this.firstLvlSubmenuLink = "" + this.firstLvlSubmenu + " > a";
        this.secondLvlSubmenuLink = "" + this.secondLvlSubmenu + " > a";
        this._hideSubmenus();
        this.mouseEvent = this.options.onHover === true ? 'mouseenter.tendina' : 'click.tendina';
        this._bindEvents();
        if (this.options.activeMenu !== null) {
          this._openActiveMenu(this.options.activeMenu);
        }
      }

      Tendina.prototype._bindEvents = function() {
        return $(document).on(this.mouseEvent, "" + this.firstLvlSubmenuLink + ", " + this.secondLvlSubmenuLink, this._eventHandler);
      };

      Tendina.prototype._unbindEvents = function() {
        return $(document).off(this.mouseEvent);
      };

      Tendina.prototype._getSelector = function(el) {
        var elId, firstClass, _ref;
        firstClass = (_ref = $(el).attr('class')) != null ? _ref.split(' ')[0] : void 0;
        elId = $(el).attr('id');
        if (elId !== void 0) {
          return "#" + elId;
        } else {
          return "." + firstClass;
        }
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
        var $targetNestedMenu, $targetNestedOpenSubmenu;
        $targetNestedMenu = $(el).next('ul');
        $targetNestedOpenSubmenu = $targetNestedMenu.find('> li.selected');
        $(el).parent().removeClass('selected');
        this._close($targetNestedMenu);
        $targetNestedOpenSubmenu.removeClass('selected');
        $targetNestedOpenSubmenu.find('> ul li').removeClass('selected');
        this._close($targetNestedOpenSubmenu.find('> ul'));
        if (this.options.closeCallback) {
          return this.options.closeCallback($(el).parent());
        }
      };

      Tendina.prototype._open = function($el) {
        if (this.options.animate) {
          return $el.stop(true, true).slideDown(this.options.speed);
        } else {
          return $el.show();
        }
      };

      Tendina.prototype._close = function($el) {
        if (this.options.animate) {
          return $el.stop(true, true).slideUp(this.options.speed);
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
        return this.$el.find('li').addClass('selected');
      };

      Tendina.prototype._openActiveMenu = function(element) {
        var $activeMenu, $activeParents;
        $activeMenu = element instanceof jQuery ? element : this.$el.find(element);
        $activeParents = $activeMenu.closest('ul').parents('li').find('> a');
        if (this._hasChildenAndIsHidden($activeParents)) {
          $activeParents.next('ul').show();
        } else {
          $activeMenu.next('ul').show();
        }
        $activeMenu.parent().addClass('selected');
        return $activeParents.parent().addClass('selected');
      };

      Tendina.prototype._checkOptions = function() {
        if (this.options.animate !== true && this.options.animate !== false) {
          console.warn("jQuery.fn.Tendina - '" + this.options.animate + "' is not a valid parameter for the 'animate' option. Falling back to default value.");
        }
        if (this.options.speed !== parseInt(this.options.speed)) {
          console.warn("jQuery.fn.Tendina - '" + this.options.speed + "' is not a valid parameter for the 'speed' option. Falling back to default value.");
        }
        if (this.options.onHover !== true && this.options.onHover !== false) {
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
