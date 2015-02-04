Tendina
=======

[![Bower version](https://badge.fury.io/bo/tendina.png)](http://badge.fury.io/bo/tendina) [![Built with Grunt](https://cdn.gruntjs.com/builtwith.png)](http://gruntjs.com/)


A super easy-to-use jQuery plugin to rapidly build dropdown side menus.

![Tendina reveals!](/demo/tendina.gif "Tendina reveals")

### Demo
* [Examples page](https://iprignano.github.io/tendina/)

* [Basic CodePen demo](http://codepen.io/iprignano/full/tjoua)

### Download

* [Download .zip archive](https://github.com/iprignano/tendina/archive/master.zip) or clone/fork this repo

* If you like Bower: `$ bower install tendina`


Usage
===

To use Tendina, you just need to have some basic markup for your menu.

That means you'll have some nested unordered lists, like this:

```html
<ul id="menu">
  <li>
    <a href="#">Menu 1</a>
    <ul>
      <li><a href="#">Submenu 1</a></li>
    </ul>
  </li>
  <li>
    <a href="#">Menu 2</a>
    <ul>
      <li><a href="#">Submenu 2</a></li>
      <li><a href="#">Submenu 2</a></li>
      <li><a href="#">Submenu 2</a>
        <ul>
          <li><a href="#">Subsubmenu 2</a></li>
          <li><a href="#">Subsubmenu 2</a></li>
        </ul>
      </li>
    </ul>
  </li>
  <li>
    <a href="#">Menu 3</a>
    <ul>
      <li><a href="#">Submenu 3</a></li>
      <li><a href="#">Submenu 3</a></li>
    </ul>
  </li>
</ul>
```

Any menu that doesn't have child menus will be treated like a normal link.

> **Heads up!** Tendina uses `<a>` tags for DOM traversing and click events management. Don't let them out! :wolf:

Next step is to have **jQuery** (>= 1.7.x) and **Tendina** loaded in your page:

```html
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="tendina.js"></script>
```

Finally, you can simply call the function on your list to transform it in a snappy side menu:

```javascript
$('#menu').tendina()
```

***

#### What Tendina does
- Provides a super easy way to setup sidemenus in a matter of minutes
- Supports infinite levels of nesting
- Hides your nested submenus and manages all interactions
- Handles dinamically added elements (nice to have when building a menu from a JSON)
- Supports multiple menu initializations on the same page
- It's lightweight – 3kb minified!

#### What Tendina does not
- Improve your social life
- Pollute your stylesheets with unnecessary CSS (read below)

I made this plugin just to handle menu interactions in a flexible way. As a result, Tendina comes with **no styles at all**.
This means you don't need to override useless CSS classes, and you have total control on the styling of your menu. Additionally, Tendina will add a "selected" class to the currently opened menu, so you can customize its looks without adding other Javascript code.

Options
===

Tendina accepts an option object, just like that:

```javascript
$('#menu').tendina({
  animate: true,
  speed: 1000,
  onHover: true,
  hoverDelay: 300,
  activeMenu: $('.my-active-menu'),
  openCallback: function(clickedEl) {
    clickedEl.addClass('opened');
  },
  closeCallback: function(clickedEl) {
    clickedEl.addClass('closed');
  }
});
```

#### **Animate**
boolean (default: true)

```javascript
animate: true
```
Set to `false` if you don't want to have slideUp/slideDown animations.

#### **Speed**
integer (default: 500)

```javascript
speed: 1000
```

Animation speed in milliseconds. Works only if `animate` is `true`.

#### **onHover**
boolean (default: false)

```javascript
onHover: true
```

Set to true if you want Tendina to open menus on mouse hover.

#### **hoverDelay**
integer (default: 200)

```javascript
hoverDelay: 350
```

The delay after which Tendina will open menus on hover. The default value fits almost any use case, but if you want to finetune it, go for it!

#### **activeMenu**
string or jQuery object (default: null)

```javascript
activeMenu: '.my-active-category'
// or
activeMenu: $('.my-active-category')
```

The active menu that will be open when a new Tendina menu is created. This is very handy if you want to show your users where they are, since Tendina will add the "selected" class to the active menu (and its parents). You can pass a selector option or a jQuery object.

#### **openCallback**
function (parameters: clickedEl)

```javascript
openCallback: function(clickedEl) {
  console.log(clickedEl); // Returns clicked jQuery <li> object
}
```

Callback that will be executed once any menu/submenu has been opened.

#### **closeCallback**
function (parameters: clickedEl)

```javascript
closeCallback: function(clickedEl) {
  console.log(clickedEl); // Returns clicked jQuery <li> object
}
```

Callback that will be executed once any menu/submenu has been closed.

*I'm working on adding more options in the next versions. Feel free to [open an issue](https://github.com/iprignano/tendina/issues) if you think Tendina should include any particular option!*

Methods
===

Tendina comes with a few handy methods.

#### **destroy**

```javascript
$('#menu').tendina('destroy')
```

Will unbind all events, remove all helper classes and open all menus, restoring the unordered list state before Tendina was called.

#### **hideAll**

```javascript
$('#menu').tendina('hideAll')
```

Will hide all open submenus.

#### **showAll**

```javascript
$('#menu').tendina('showAll')
```

Will show all submenus.


*I'm working on adding more methods in the next versions. Feel free to [open an issue](https://github.com/iprignano/tendina/issues) if you think Tendina should include any particular method!*

Contributing
===

Contributions are welcome! In order to contribute, you can use the [Fork & Pull Model](https://help.github.com/articles/using-pull-requests#fork--pull).

Tendina comes with a easy-to-use Grunt configuration.

Given you have `npm` and `grunt-cli` installed, you just need to run `npm install` in the project folder once to install all the dev dependencies.
Then, just execute `grunt watch`: this way Grunt will spawn a watcher that will compile the Coffee and minify the resulting Javascript everytime you edit `tendina.coffee`.

License
===

Tendina is released under the MIT License.

The MIT License (MIT)

Copyright (c) 2015 Ivan Prignano

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.