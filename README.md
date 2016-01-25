# glaze-engine

A 2D webgl browser game engine.

Utilizes all the glaze sub projects:

- core
- eco
- physics
- render

Local Build

To build locally you'll need to:

* Install haxe
* Checkout this repo somewhere
* Install the haxelib dependancies; note you need to install them from github as they are not published yet
```
haxelib git glaze-core https://github.com/rjewson/glaze-core
haxelib git glaze-render https://github.com/rjewson/glaze-render
haxelib git glaze-eco https://github.com/rjewson/glaze-eco
haxelib install compiletime
```
* Run the build.hxml
* Open the bin/index.html to see the game.  You'll need to serve this via a proper HTTP server (not just the file system).

TODO
Add static, dynamic and kinematic components

Map
Static Solid	
Static Sensor

Dynamic [Map,All Static,Dynamic Sensors]
Dynamic [Map,All Static,Dynamic Sensors,Dynamic] < Is this rays/projectiles only?