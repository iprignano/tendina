Tendina
=======

A super easy-to-use jQuery plugin to build rapidly dropdown side menus.

Usage
===

To use Tendina, you need to have some basic markup for your menu. That means you need to have some unordered lists, nested:

```html
<ul class="dropdown">
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
      <li><a href="#">Submenu 2</a></li>
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
Then, you need to link jQuery and tendina.js in your body:

```html
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="tendina.js"></script>
```

And, finally, call the function on your list menu:

```javascript
$('.dropdown').tendina()
```

Tendina will hide your nested submenus and manage all interactions with a nice slideUp/Down effect. You can even call Tendina on dinamically added elements (nice to have when building a menu from a JSON tree)!

License
===

Tendina is released under the MIT License.