# Rib

## A foundation library for building [CoffeeScript][] ##

Rib consists of a collection of production-quality essential and highly useful classes, mixins and functions.

Rib is thoroughly tested using [Jasmine][].

Rib works both on the client (browser) and on the server ([Node.js][]).

Rib is extremely lightweight (1.3K minified and compressed).

### Installation ###

To use Rib with [Node.js][], just use npm:

    sudo npm install -g rib

To use Rib on the client, just grab [rib.js][] or [rib.min.js][] and put it with your other JavaScript libraries.

### Usage ###

When writing code for [Node.js][], you can require Rib:

```coffeescript
rib = require "rib"
```

On the client, include [rib.js][] or [rib.min.js][], and then you can access it through the global module `rib`.

If you want to target both the server and the client, you can write:

```coffeescript
rib = if require? then require("rib") else window.rib
```

### Licence ###

Rib is © 2012 Marco Pantaleoni, released under the MIT licence. Use it, fork it.

[CoffeeScript]: http://jashkenas.github.com/coffee-script/
[Node.js]: http://nodejs.org/
[Jasmine]: http://pivotal.github.com/jasmine/
[rib.js]: https://raw.github.com/panta/rib/master/dist/rib.js
[rib.min.js]: [https://raw.github.com/panta/rib/master/dist/rib.min.js
