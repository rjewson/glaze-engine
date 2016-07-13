[![Stories in Ready](https://badge.waffle.io/rjewson/glaze-engine.png?label=ready&title=Ready)](https://waffle.io/rjewson/glaze-engine)
# glaze-engine

A game engine built with Haxe. 

- Designed around the Entity-component-system archectural pattern
    - Uses glaze-eco
    - All aspects of the engine are fully integrated (physics, graphics, ai etc)
- High performance custom 2D physics
- Efficient OpenGL/WebGL render
    - Quad Sprite renderer
    - Point Sprite renderer
    - Custom tile map renderer (GPU)
        - Example project is rendering 3 layers of 50*40 tiles (6000 tiles) each frame with minimal CPU overhead
- Desisgned to manage massive concurent game worlds with large numbers of entities
- Steering behaviours
- Behaviour Tree
- FSM's

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

https://waffle.io/rjewson/glaze-engine