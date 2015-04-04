
/*
Tendina jQuery plugin v0.11.1

Copyright (c) 2015 Ivan Prignano
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
        this.elSelector = this._getSelector(this.$el);
        this.$el.addClass('tendina');
        this.linkSelector = "" + this.elSelector + " a";
        this.$listElements = $(this.linkSelector).parent('li');
        this._hideSubmenus();
        this.mouseEvent = this.options.onHover === true ? 'mouseenter.tendina' : 'click.tendina';
        this._bindEvents();
        if (this.options.activeMenu !== null) {
          this._openActiveMenu(this.options.activeMenu);
        }
      }

      Tendina.prototype._bindEvents = function() {
        return $(document).on(this.mouseEvent, this.linkSelector, this._eventHandler);
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
        var targetEl;
        targetEl = event.currentTarget;
        if (this._hasChildren(targetEl) && this._IsChildrenHidden(targetEl)) {
          event.preventDefault();
          if (this.options.onHover) {
            return setTimeout((function(_this) {
              return function() {
                if ($(targetEl).is(':hover')) {
                  return _this._openSubmenu(targetEl);
                }
              };
            })(this), this.options.hoverDelay);
          } else {
            return this._openSubmenu(targetEl);
          }
        } else if (this._isCurrentlyOpen(targetEl) && this._hasChildren(targetEl)) {
          event.preventDefault();
          if (!this.options.onHover) {
            return this._closeSubmenu(targetEl);
          }
        }
      };

      Tendina.prototype._openSubmenu = function(el) {
        var $openMenus, $targetMenu;
        $targetMenu = $(el).next('ul');
        $openMenus = this.$el.find('> .selected ul').not($targetMenu).not($targetMenu.parents('ul'));
        $(el).parent('li').addClass('selected');
        this._close($openMenus);
        this.$el.find('.selected').not($targetMenu.parents('li')).removeClass('selected');
        this._open($targetMenu);
        if (this.options.openCallback) {
          return this.options.openCallback($(el).parent());
        }
      };

      Tendina.prototype._closeSubmenu = function(el) {
        var $nestedMenus, $targetMenu;
        $targetMenu = $(el).next('ul');
        $nestedMenus = $targetMenu.find('li.selected');
        $(el).parent().removeClass('selected');
        this._close($targetMenu);
        $nestedMenus.removeClass('selected');
        this._close($nestedMenus.find('ul'));
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

      Tendina.prototype._hasChildren = function(el) {
        return $(el).next('ul').length > 0;
      };

      Tendina.prototype._IsChildrenHidden = function(el) {
        return $(el).next('ul').is(':hidden');
      };

      Tendina.prototype._isCurrentlyOpen = function(el) {
        return $(el).parent().hasClass('selected');
      };

      Tendina.prototype._hideSubmenus = function() {
        return this.$el.find('ul').hide();
      };

      Tendina.prototype._showSubmenus = function() {
        this.$el.find('ul').show();
        return this.$el.find('li').addClass('selected');
      };

      Tendina.prototype._openActiveMenu = function(element) {
        var $activeMenu, $activeParents;
        $activeMenu = element instanceof jQuery ? element : this.$el.find(element);
        $activeParents = $activeMenu.closest('ul').parents('li').find('> a');
        if (this._hasChildren($activeParents) && this._IsChildrenHidden($activeParents)) {
          $activeParents.next('ul').show();
        } else {
          $activeMenu.next('ul').show();
        }
        $activeMenu.parent().addClass('selected');
        return $activeParents.parent().addClass('selected');
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
