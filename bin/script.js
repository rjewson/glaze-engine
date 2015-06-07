(function (console) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var glaze_engine_core_GameEngine = function(canvas) {
	this.canvas = canvas;
	this.loop = new glaze_core_GameLoop();
	this.loop.updateFunc = $bind(this,this.update);
	this.input = new glaze_core_DigitalInput();
	var rect = canvas.getBoundingClientRect();
	this.input.InputTarget(window.document,new glaze_geom_Vector2(rect.left,rect.top));
	this.engine = new glaze_eco_core_Engine();
};
glaze_engine_core_GameEngine.__name__ = ["glaze","engine","core","GameEngine"];
glaze_engine_core_GameEngine.prototype = {
	loadAssets: function(assetList) {
		this.assets = new glaze_util_AssetLoader();
		this.assets.loaded.add($bind(this,this.initalize));
		this.assets.SetImagesToLoad(assetList);
		this.assets.Load();
	}
	,initalize: function() {
	}
	,update: function(delta,now) {
		this.input.Update(0,0);
		this.preUpdate();
		this.engine.update(now,delta);
		this.postUpdate();
	}
	,preUpdate: function() {
	}
	,postUpdate: function() {
	}
	,__class__: glaze_engine_core_GameEngine
};
var GameTestA = function() {
	glaze_engine_core_GameEngine.call(this,js_Boot.__cast(window.document.getElementById("view") , HTMLCanvasElement));
	this.loadAssets(["data/testMap.tmx","data/sprites.json","data/sprites.png","data/spelunky-tiles.png","data/spelunky0.png","data/spelunky1.png"]);
};
GameTestA.__name__ = ["GameTestA"];
GameTestA.main = function() {
	var game = new GameTestA();
	window.document.getElementById("stopbutton").addEventListener("click",function(event) {
		game.loop.stop();
	});
	window.document.getElementById("startbutton").addEventListener("click",function(event1) {
		game.loop.start();
	});
};
GameTestA.__super__ = glaze_engine_core_GameEngine;
GameTestA.prototype = $extend(glaze_engine_core_GameEngine.prototype,{
	initalize: function() {
		this.setupMap();
		var corephase = this.engine.createPhase();
		var aiphase = this.engine.createPhase(1000);
		var physicsPhase = this.engine.createPhase(16.6666666666666679);
		var renderSystem = new glaze_engine_systems_RenderSystem(this.canvas);
		var tmp;
		var _this = this.assets.assets;
		if(__map_reserved["data/sprites.png"] != null) tmp = _this.getReserved("data/sprites.png"); else tmp = _this.h["data/sprites.png"];
		renderSystem.textureManager.AddTexture("data/sprites.png",tmp);
		var tmp1;
		var _this1 = this.assets.assets;
		if(__map_reserved["data/sprites.json"] != null) tmp1 = _this1.getReserved("data/sprites.json"); else tmp1 = _this1.h["data/sprites.json"];
		renderSystem.textureManager.ParseTexturePackerJSON(tmp1,"data/sprites.png");
		var mapData = glaze_tmx_TmxLayer.LayerToCoordTexture(this.tmxMap.getLayer("Tile Layer 1"));
		var tileMap = new glaze_render_renderers_webgl_TileMap();
		renderSystem.renderer.AddRenderer(tileMap);
		var tmp2;
		var _this2 = this.assets.assets;
		if(__map_reserved["data/spelunky-tiles.png"] != null) tmp2 = _this2.getReserved("data/spelunky-tiles.png"); else tmp2 = _this2.h["data/spelunky-tiles.png"];
		tileMap.SetSpriteSheet(tmp2);
		tileMap.SetTileLayerFromData(mapData,"base",1,1);
		var tmp3;
		var _this3 = this.assets.assets;
		if(__map_reserved["data/spelunky1.png"] != null) tmp3 = _this3.getReserved("data/spelunky1.png"); else tmp3 = _this3.h["data/spelunky1.png"];
		tileMap.SetTileLayer(tmp3,"bg",0.6,0.6);
		tileMap.tileSize = 16;
		tileMap.TileScale(2);
		var spriteRender = new glaze_render_renderers_webgl_SpriteRenderer();
		spriteRender.AddStage(renderSystem.stage);
		renderSystem.renderer.AddRenderer(spriteRender);
		var blockParticleEngine = new glaze_particle_BlockSpriteParticleEngine(4000,16.6666666666666679);
		renderSystem.renderer.AddRenderer(blockParticleEngine.renderer);
		var map = new glaze_physics_collision_Map(this.tmxMap.getLayer("Tile Layer 1").tileGIDs);
		physicsPhase.addSystem(new glaze_physics_systems_PhysicsUpdateSystem());
		physicsPhase.addSystem(new glaze_physics_systems_PhysicsCollisionSystem(new glaze_physics_collision_broadphase_BruteforceBroadphase(map,new glaze_physics_collision_Intersect())));
		physicsPhase.addSystem(new glaze_physics_systems_PhysicsUpdateSystem());
		aiphase.addSystem(new glaze_engine_systems_BehaviourSystem());
		corephase.addSystem(new glaze_engine_systems_ParticleSystem(blockParticleEngine));
		corephase.addSystem(renderSystem);
		var behavior = new glaze_ai_behaviortree_Sequence();
		var child = new glaze_engine_actions_LogAction();
		behavior.children.add(child);
		var player = this.engine.create([new glaze_engine_components_Position(100,100),new glaze_engine_components_Display("character1.png"),new glaze_engine_components_Physics(15.,36.,new glaze_physics_Material()),new glaze_engine_components_Script(behavior),new glaze_engine_components_ParticleEmitters([new glaze_particle_emitter_RandomSpray(0,10)])]);
		var tmp4;
		var value = player.map.Physics;
		if((value instanceof glaze_engine_components_Physics)) tmp4 = value; else tmp4 = null;
		var playerBody = tmp4.body;
		this.characterController = new util_CharacterController(this.input,playerBody);
		playerBody.maxScalarVelocity = 0;
		var _this4 = playerBody.maxVelocity;
		_this4.x = 160;
		_this4.y = 1000;
		var tmp5;
		var value1 = player.map.Position;
		if((value1 instanceof glaze_engine_components_Position)) tmp5 = value1; else tmp5 = null;
		renderSystem.CameraTarget(tmp5.coords);
	}
	,setupMap: function() {
		var tmp;
		var _this = this.assets.assets;
		if(__map_reserved["data/testMap.tmx"] != null) tmp = _this.getReserved("data/testMap.tmx"); else tmp = _this.h["data/testMap.tmx"];
		this.tmxMap = new glaze_tmx_TmxMap(tmp);
		var tmp1;
		var _this1 = this.assets.assets;
		if(__map_reserved["data/spelunky-tiles.png"] != null) tmp1 = _this1.getReserved("data/spelunky-tiles.png"); else tmp1 = _this1.h["data/spelunky-tiles.png"];
		this.tmxMap.tilesets[0].set_image(tmp1);
	}
	,preUpdate: function() {
		this.characterController.update();
	}
	,__class__: GameTestA
});
var HxOverrides = function() { };
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.remove = function(a,obj) {
	var i = HxOverrides.indexOf(a,obj,0);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
Lambda.__name__ = ["Lambda"];
Lambda.map = function(it,f) {
	var l = new List();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(x));
	}
	return l;
};
var List = function() {
	this.length = 0;
};
List.__name__ = ["List"];
List.prototype = {
	add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	}
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l[0] == v) {
				if(prev == null) this.h = l[1]; else prev[1] = l[1];
				if(this.q == l) this.q = prev;
				this.length--;
				return true;
			}
			prev = l;
			l = l[1];
		}
		return false;
	}
	,join: function(sep) {
		var s_b = "";
		var first = true;
		var l = this.h;
		while(l != null) {
			if(first) first = false; else s_b += sep == null?"null":"" + sep;
			var x = l[0];
			s_b += Std.string(x);
			l = l[1];
		}
		return s_b;
	}
	,__class__: List
};
var _$List_ListIterator = function(head) {
	this.head = head;
	this.val = null;
};
_$List_ListIterator.__name__ = ["_List","ListIterator"];
_$List_ListIterator.prototype = {
	hasNext: function() {
		return this.head != null;
	}
	,next: function() {
		this.val = this.head[0];
		this.head = this.head[1];
		return this.val;
	}
	,__class__: _$List_ListIterator
};
Math.__name__ = ["Math"];
var Reflect = function() { };
Reflect.__name__ = ["Reflect"];
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		return null;
	}
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
};
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
};
Reflect.deleteField = function(o,field) {
	if(!Object.prototype.hasOwnProperty.call(o,field)) return false;
	delete(o[field]);
	return true;
};
var Std = function() { };
Std.__name__ = ["Std"];
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	__class__: StringBuf
};
var StringTools = function() { };
StringTools.__name__ = ["StringTools"];
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
var Type = function() { };
Type.__name__ = ["Type"];
Type.getClassName = function(c) {
	var a = c.__name__;
	if(a == null) return null;
	return a.join(".");
};
var Xml = function(nodeType) {
	this.nodeType = nodeType;
	this.children = [];
	this.attributeMap = new haxe_ds_StringMap();
};
Xml.__name__ = ["Xml"];
Xml.parse = function(str) {
	return haxe_xml_Parser.parse(str);
};
Xml.createElement = function(name) {
	var xml = new Xml(Xml.Element);
	if(xml.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + xml.nodeType);
	xml.nodeName = name;
	return xml;
};
Xml.createPCData = function(data) {
	var xml = new Xml(Xml.PCData);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createCData = function(data) {
	var xml = new Xml(Xml.CData);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createComment = function(data) {
	var xml = new Xml(Xml.Comment);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createDocType = function(data) {
	var xml = new Xml(Xml.DocType);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createProcessingInstruction = function(data) {
	var xml = new Xml(Xml.ProcessingInstruction);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createDocument = function() {
	return new Xml(Xml.Document);
};
Xml.prototype = {
	get: function(att) {
		if(this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + this.nodeType);
		var tmp;
		var _this = this.attributeMap;
		if(__map_reserved[att] != null) tmp = _this.getReserved(att); else tmp = _this.h[att];
		return tmp;
	}
	,set: function(att,value) {
		if(this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + this.nodeType);
		var _this = this.attributeMap;
		if(__map_reserved[att] != null) _this.setReserved(att,value); else _this.h[att] = value;
	}
	,exists: function(att) {
		if(this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + this.nodeType);
		var tmp;
		var _this = this.attributeMap;
		if(__map_reserved[att] != null) tmp = _this.existsReserved(att); else tmp = _this.h.hasOwnProperty(att);
		return tmp;
	}
	,elementsNamed: function(name) {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + this.nodeType);
		var tmp;
		var _g = [];
		var _g1 = 0;
		var _g2 = this.children;
		while(_g1 < _g2.length) {
			var child = _g2[_g1];
			++_g1;
			var tmp1;
			if(child.nodeType == Xml.Element) {
				var tmp2;
				if(child.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + child.nodeType);
				tmp2 = child.nodeName;
				tmp1 = tmp2 == name;
			} else tmp1 = false;
			if(tmp1) _g.push(child);
		}
		tmp = _g;
		var ret = tmp;
		return HxOverrides.iter(ret);
	}
	,addChild: function(x) {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + this.nodeType);
		if(x.parent != null) x.parent.removeChild(x);
		this.children.push(x);
		x.parent = this;
	}
	,removeChild: function(x) {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + this.nodeType);
		if(HxOverrides.remove(this.children,x)) {
			x.parent = null;
			return true;
		}
		return false;
	}
	,__class__: Xml
};
var glaze_ai_behaviortree_Behavior = function() {
	this.status = glaze_ai_behaviortree_BehaviorStatus.Invalid;
};
glaze_ai_behaviortree_Behavior.__name__ = ["glaze","ai","behaviortree","Behavior"];
glaze_ai_behaviortree_Behavior.prototype = {
	initialize: function(context) {
	}
	,terminate: function(status) {
	}
	,update: function(context) {
		return this.status;
	}
	,get_terminated: function() {
		return this.status == glaze_ai_behaviortree_BehaviorStatus.Success || this.status == glaze_ai_behaviortree_BehaviorStatus.Failure;
	}
	,get_running: function() {
		return this.status == glaze_ai_behaviortree_BehaviorStatus.Running;
	}
	,reset: function() {
		this.status = glaze_ai_behaviortree_BehaviorStatus.Invalid;
	}
	,abort: function() {
		this.terminate(glaze_ai_behaviortree_BehaviorStatus.Aborted);
		this.status = glaze_ai_behaviortree_BehaviorStatus.Aborted;
	}
	,tick: function(context) {
		if(this.status != glaze_ai_behaviortree_BehaviorStatus.Running) this.initialize(context);
		this.status = this.update(context);
		if(this.status != glaze_ai_behaviortree_BehaviorStatus.Running) this.terminate(this.status);
		return this.status;
	}
	,__class__: glaze_ai_behaviortree_Behavior
};
var glaze_ai_behaviortree_BehaviorContext = function(entity) {
	this.entity = entity;
	this.time = 0;
	this.data = { };
};
glaze_ai_behaviortree_BehaviorContext.__name__ = ["glaze","ai","behaviortree","BehaviorContext"];
glaze_ai_behaviortree_BehaviorContext.prototype = {
	__class__: glaze_ai_behaviortree_BehaviorContext
};
var glaze_ai_behaviortree_BehaviorStatus = { __ename__ : true, __constructs__ : ["Invalid","Success","Running","Failure","Aborted"] };
glaze_ai_behaviortree_BehaviorStatus.Invalid = ["Invalid",0];
glaze_ai_behaviortree_BehaviorStatus.Invalid.toString = $estr;
glaze_ai_behaviortree_BehaviorStatus.Invalid.__enum__ = glaze_ai_behaviortree_BehaviorStatus;
glaze_ai_behaviortree_BehaviorStatus.Success = ["Success",1];
glaze_ai_behaviortree_BehaviorStatus.Success.toString = $estr;
glaze_ai_behaviortree_BehaviorStatus.Success.__enum__ = glaze_ai_behaviortree_BehaviorStatus;
glaze_ai_behaviortree_BehaviorStatus.Running = ["Running",2];
glaze_ai_behaviortree_BehaviorStatus.Running.toString = $estr;
glaze_ai_behaviortree_BehaviorStatus.Running.__enum__ = glaze_ai_behaviortree_BehaviorStatus;
glaze_ai_behaviortree_BehaviorStatus.Failure = ["Failure",3];
glaze_ai_behaviortree_BehaviorStatus.Failure.toString = $estr;
glaze_ai_behaviortree_BehaviorStatus.Failure.__enum__ = glaze_ai_behaviortree_BehaviorStatus;
glaze_ai_behaviortree_BehaviorStatus.Aborted = ["Aborted",4];
glaze_ai_behaviortree_BehaviorStatus.Aborted.toString = $estr;
glaze_ai_behaviortree_BehaviorStatus.Aborted.__enum__ = glaze_ai_behaviortree_BehaviorStatus;
var glaze_ai_behaviortree_Composite = function() {
	glaze_ai_behaviortree_Behavior.call(this);
	this.children = new List();
};
glaze_ai_behaviortree_Composite.__name__ = ["glaze","ai","behaviortree","Composite"];
glaze_ai_behaviortree_Composite.__super__ = glaze_ai_behaviortree_Behavior;
glaze_ai_behaviortree_Composite.prototype = $extend(glaze_ai_behaviortree_Behavior.prototype,{
	addChild: function(child) {
		this.children.add(child);
	}
	,removeChild: function(child) {
		this.children.remove(child);
	}
	,removeAll: function() {
		this.children.clear();
	}
	,__class__: glaze_ai_behaviortree_Composite
});
var glaze_ai_behaviortree_Sequence = function() {
	glaze_ai_behaviortree_Composite.call(this);
};
glaze_ai_behaviortree_Sequence.__name__ = ["glaze","ai","behaviortree","Sequence"];
glaze_ai_behaviortree_Sequence.__super__ = glaze_ai_behaviortree_Composite;
glaze_ai_behaviortree_Sequence.prototype = $extend(glaze_ai_behaviortree_Composite.prototype,{
	initialize: function(context) {
		this._current = new _$List_ListIterator(this.children.h);
		this._currentBehavior = this._current.next();
	}
	,update: function(context) {
		while(this._currentBehavior != null) {
			var status = this._currentBehavior.tick(context);
			if(status != glaze_ai_behaviortree_BehaviorStatus.Success) return status;
			if(this._current.hasNext()) this._currentBehavior = this._current.next(); else break;
		}
		return glaze_ai_behaviortree_BehaviorStatus.Success;
	}
	,__class__: glaze_ai_behaviortree_Sequence
});
var glaze_core_DigitalInput = function() {
	this.keyMap = [];
	var _g = 0;
	while(_g < 255) {
		var i = _g++;
		this.keyMap[i] = 0;
	}
	this.mousePosition = new glaze_geom_Vector2();
	this.mousePreviousPosition = new glaze_geom_Vector2();
	this.mouseOffset = new glaze_geom_Vector2();
	this.frameRef = 2;
};
glaze_core_DigitalInput.__name__ = ["glaze","core","DigitalInput"];
glaze_core_DigitalInput.prototype = {
	InputTarget: function(target,inputCorrection) {
		this.target = target;
		target.addEventListener("keydown",$bind(this,this.KeyDown),false);
		target.addEventListener("keyup",$bind(this,this.KeyUp),false);
		target.addEventListener("mousedown",$bind(this,this.MouseDown),false);
		target.addEventListener("mouseup",$bind(this,this.MouseUp),false);
		target.addEventListener("mousemove",$bind(this,this.MouseMove),false);
		this.inputCorrection = inputCorrection;
	}
	,Update: function(x,y) {
		this.mouseOffset.x = x;
		this.mouseOffset.y = y;
		this.frameRef++;
	}
	,KeyDown: function(event) {
		if(this.keyMap[event.keyCode] == 0) this.keyMap[event.keyCode] = this.frameRef;
		event.preventDefault();
	}
	,KeyUp: function(event) {
		this.keyMap[event.keyCode] = 0;
		event.preventDefault();
	}
	,MouseDown: function(event) {
		this.keyMap[200] = this.frameRef;
		event.preventDefault();
	}
	,MouseUp: function(event) {
		this.keyMap[200] = 0;
		event.preventDefault();
	}
	,MouseMove: function(event) {
		this.mousePreviousPosition.x = this.mousePosition.x;
		this.mousePreviousPosition.y = this.mousePosition.y;
		this.mousePosition.x = event.clientX - this.inputCorrection.x;
		this.mousePosition.y = event.clientY - this.inputCorrection.y;
		event.preventDefault();
	}
	,Pressed: function(keyCode) {
		return this.keyMap[keyCode] > 0;
	}
	,JustPressed: function(keyCode) {
		return this.keyMap[keyCode] == this.frameRef - 1;
	}
	,PressedDuration: function(keyCode) {
		var duration = this.keyMap[keyCode];
		return duration > 0?this.frameRef - duration:-1;
	}
	,Released: function(keyCode) {
		return this.keyMap[keyCode] == 0;
	}
	,__class__: glaze_core_DigitalInput
};
var glaze_core_GameLoop = function() {
	this.isRunning = false;
};
glaze_core_GameLoop.__name__ = ["glaze","core","GameLoop"];
glaze_core_GameLoop.prototype = {
	update: function(timestamp) {
		this.delta = this.prevAnimationTime == 0?16.6666666766666687:timestamp - this.prevAnimationTime;
		this.prevAnimationTime = timestamp;
		if(this.updateFunc != null) this.updateFunc(Math.max(this.delta,16.6666666766666687),Math.floor(timestamp));
		this.rafID = window.requestAnimationFrame($bind(this,this.update));
		return false;
	}
	,start: function() {
		if(this.isRunning == true) return;
		this.isRunning = true;
		this.prevAnimationTime = 0;
		this.rafID = window.requestAnimationFrame($bind(this,this.update));
	}
	,stop: function() {
		if(this.isRunning == false) return;
		this.isRunning = false;
		window.cancelAnimationFrame(this.rafID);
	}
	,__class__: glaze_core_GameLoop
};
var glaze_ds_Bytes2D = function(width,height,cellSize,bytesPerCell,data) {
	this.initalize(width,height,cellSize,bytesPerCell,data);
};
glaze_ds_Bytes2D.__name__ = ["glaze","ds","Bytes2D"];
glaze_ds_Bytes2D.uncompressData = function(str,compressed) {
	if(compressed == null) compressed = true;
	var mapbytes = haxe_crypto_Base64.decode(str);
	if(compressed) mapbytes = haxe_zip_Uncompress.run(mapbytes);
	return mapbytes;
};
glaze_ds_Bytes2D.prototype = {
	initalize: function(width,height,cellSize,bytesPerCell,data) {
		this.width = width;
		this.height = height;
		this.internalWidth = width * bytesPerCell;
		this.cellSize = cellSize;
		this.invCellSize = 1 / cellSize;
		this.bytesPerCell = bytesPerCell;
		if(data == null) this.data = haxe_io_Bytes.alloc(width * height * bytesPerCell); else this.data = data;
		this.bytesData = this.data.b.bufferValue;
	}
	,get: function(x,y,offset) {
		return this.data.b[y * this.internalWidth + x * this.bytesPerCell + offset];
	}
	,set: function(x,y,offset,value) {
		this.data.b[y * this.internalWidth + x * this.bytesPerCell + offset] = value & 255;
	}
	,Index: function(value) {
		return value * this.invCellSize | 0;
	}
	,__class__: glaze_ds_Bytes2D
};
var glaze_ds__$DynamicObject_DynamicObject_$Impl_$ = {};
glaze_ds__$DynamicObject_DynamicObject_$Impl_$.__name__ = ["glaze","ds","_DynamicObject","DynamicObject_Impl_"];
glaze_ds__$DynamicObject_DynamicObject_$Impl_$._new = function() {
	return { };
};
glaze_ds__$DynamicObject_DynamicObject_$Impl_$.set = function(this1,key,value) {
	this1[key] = value;
};
glaze_ds__$DynamicObject_DynamicObject_$Impl_$.get = function(this1,key) {
	return this1[key];
};
glaze_ds__$DynamicObject_DynamicObject_$Impl_$.exists = function(this1,key) {
	return Object.prototype.hasOwnProperty.call(this1,key);
};
glaze_ds__$DynamicObject_DynamicObject_$Impl_$.remove = function(this1,key) {
	return Reflect.deleteField(this1,key);
};
glaze_ds__$DynamicObject_DynamicObject_$Impl_$.keys = function(this1) {
	return Reflect.fields(this1);
};
var glaze_ds_TypedArray2D = function(width,height,buffer) {
	this.w = width;
	this.h = height;
	if(buffer == null) this.buffer = new ArrayBuffer(this.w * this.h * 4); else this.buffer = buffer;
	this.data32 = new Uint32Array(this.buffer);
	this.data8 = new Uint8Array(this.buffer);
};
glaze_ds_TypedArray2D.__name__ = ["glaze","ds","TypedArray2D"];
glaze_ds_TypedArray2D.prototype = {
	get: function(x,y) {
		return this.data32[y * this.w + x];
	}
	,set: function(x,y,v) {
		this.data32[y * this.w + x] = v;
	}
	,getIndex: function(x,y) {
		return y * this.w + x;
	}
	,__class__: glaze_ds_TypedArray2D
};
var glaze_eco_core_Engine = function() {
	this.entities = [];
	this.phases = [];
	this.systems = [];
	this.systemMap = new haxe_ds_StringMap();
	this.componentAddedToEntity = new glaze_signals_Signal2();
	this.componentRemovedFromEntity = new glaze_signals_Signal2();
	this.systemAdded = new glaze_signals_Signal1();
	this.systemAdded.add($bind(this,this.onSystemAdded));
	this.viewManager = new glaze_eco_core_ViewManager(this);
};
glaze_eco_core_Engine.__name__ = ["glaze","eco","core","Engine"];
glaze_eco_core_Engine.prototype = {
	create: function(components) {
		var entity = new glaze_eco_core_Entity(this,components);
		this.entities.push(entity);
		return entity;
	}
	,createPhase: function(msPerUpdate) {
		if(msPerUpdate == null) msPerUpdate = 0;
		var phase = new glaze_eco_core_Phase(this,msPerUpdate);
		this.phases.push(phase);
		return phase;
	}
	,onSystemAdded: function(system) {
		this.systems.push(system);
		var _this = this.systemMap;
		var key = Type.getClassName(system == null?null:js_Boot.getClass(system));
		if(__map_reserved[key] != null) _this.setReserved(key,system); else _this.h[key] = system;
	}
	,getSystem: function(systemClass) {
		return (function($this) {
			var $r;
			var _this = $this.systemMap;
			var key = Type.getClassName(systemClass);
			$r = __map_reserved[key] != null?_this.getReserved(key):_this.h[key];
			return $r;
		}(this));
	}
	,update: function(timestamp,delta) {
		var _g = 0;
		var _g1 = this.phases;
		while(_g < _g1.length) {
			var phase = _g1[_g];
			++_g;
			phase.update(timestamp,delta);
		}
	}
	,__class__: glaze_eco_core_Engine
};
var glaze_eco_core_Entity = function(engine,components) {
	this.list = [];
	this.map = { };
	this.id = 0;
	this.engine = engine;
	if(components != null) this.addManyComponent(components);
};
glaze_eco_core_Entity.__name__ = ["glaze","eco","core","Entity"];
glaze_eco_core_Entity.GET_NAME_FROM_COMPONENT = function(component) {
	return Reflect.field(component == null?null:js_Boot.getClass(component),"NAME");
};
glaze_eco_core_Entity.prototype = {
	addComponent: function(component) {
		var name = Reflect.field(component == null?null:js_Boot.getClass(component),"NAME");
		if(Object.prototype.hasOwnProperty.call(this.map,name)) {
			HxOverrides.remove(this.list,component);
			Reflect.deleteField(this.map,name);
		}
		this.map[name] = component;
		this.list.push(component);
		this.engine.componentAddedToEntity.dispatch(this,component);
	}
	,addManyComponent: function(components) {
		var _g = 0;
		while(_g < components.length) {
			var component = components[_g];
			++_g;
			this.addComponent(component);
		}
	}
	,removeComponent: function(component) {
		var name = Reflect.field(component == null?null:js_Boot.getClass(component),"NAME");
		if(Object.prototype.hasOwnProperty.call(this.map,name)) {
			HxOverrides.remove(this.list,component);
			Reflect.deleteField(this.map,name);
			this.engine.componentRemovedFromEntity.dispatch(this,component);
		}
	}
	,get: function(key) {
		return this.map[key];
	}
	,add: function(key,value) {
		this.map[key] = value;
		this.list.push(value);
	}
	,exists: function(key) {
		return Object.prototype.hasOwnProperty.call(this.map,key);
	}
	,remove: function(key,value) {
		HxOverrides.remove(this.list,value);
		return Reflect.deleteField(this.map,key);
	}
	,__class__: glaze_eco_core_Entity
};
var glaze_eco_core_IComponent = function() { };
glaze_eco_core_IComponent.__name__ = ["glaze","eco","core","IComponent"];
var glaze_eco_core_Phase = function(engine,msPerUpdate,maxAccumulatedDelta) {
	if(maxAccumulatedDelta == null) maxAccumulatedDelta = 0;
	if(msPerUpdate == null) msPerUpdate = 0;
	this.systems = [];
	this.engine = engine;
	this.msPerUpdate = msPerUpdate;
	this.enabled = true;
	this.accumulator = 0;
	this.updateCount = 0;
};
glaze_eco_core_Phase.__name__ = ["glaze","eco","core","Phase"];
glaze_eco_core_Phase.prototype = {
	update: function(timestamp,delta) {
		if(!this.enabled) return;
		if(this.msPerUpdate != 0) {
			this.accumulator += delta;
			while(this.accumulator > this.msPerUpdate) {
				this.updateCount++;
				this.accumulator -= this.msPerUpdate;
				var _g = 0;
				var _g1 = this.systems;
				while(_g < _g1.length) {
					var system = _g1[_g];
					++_g;
					system.update(timestamp,this.msPerUpdate);
				}
			}
		} else {
			var _g2 = 0;
			var _g11 = this.systems;
			while(_g2 < _g11.length) {
				var system1 = _g11[_g2];
				++_g2;
				system1.update(timestamp,delta);
			}
		}
	}
	,addSystem: function(system) {
		this.systems.push(system);
		this.engine.systemAdded.dispatch(system);
	}
	,addSystemAfter: function(system,after) {
		var i = HxOverrides.indexOf(this.systems,after,0);
		if(i < 0) return false;
		this.systems.splice(i + 1,0,system);
		this.engine.systemAdded.dispatch(system);
		return true;
	}
	,addSystemBefore: function(system,before) {
		var i = HxOverrides.indexOf(this.systems,before,0);
		if(i < 0) return false;
		this.systems.splice(i,0,system);
		this.engine.systemAdded.dispatch(system);
		return true;
	}
	,__class__: glaze_eco_core_Phase
};
var glaze_eco_core_System = function(componentSignature) {
	this.registeredComponents = componentSignature;
	this.enabled = true;
};
glaze_eco_core_System.__name__ = ["glaze","eco","core","System"];
glaze_eco_core_System.prototype = {
	onAdded: function(engine) {
		this.engine = engine;
	}
	,onRemoved: function() {
	}
	,entityAdded: function(entity) {
	}
	,entityRemoved: function(entity) {
	}
	,update: function(timestamp,delta) {
	}
	,__class__: glaze_eco_core_System
};
var glaze_eco_core_View = function(components) {
	this.entityRemoved = new glaze_signals_Signal1();
	this.entityAdded = new glaze_signals_Signal1();
	this.registeredComponents = null;
	this.entities = [];
	this.registeredComponents = components;
};
glaze_eco_core_View.__name__ = ["glaze","eco","core","View"];
glaze_eco_core_View.prototype = {
	addEntity: function(entity) {
		this.entities.push(entity);
		this.entityAdded.dispatch(entity);
	}
	,removeEntity: function(entity) {
		if(HxOverrides.remove(this.entities,entity)) this.entityRemoved.dispatch(entity);
	}
	,__class__: glaze_eco_core_View
};
var glaze_eco_core_ViewManager = function(engine) {
	this.componentViewMap = new haxe_ds_StringMap();
	this.views = [];
	this.engine = engine;
	engine.componentAddedToEntity.add($bind(this,this.matchViews));
	engine.componentRemovedFromEntity.add($bind(this,this.unmatchViews));
	engine.systemAdded.add($bind(this,this.injectView));
};
glaze_eco_core_ViewManager.__name__ = ["glaze","eco","core","ViewManager"];
glaze_eco_core_ViewManager.prototype = {
	getView: function(components,forceUpdate) {
		if(forceUpdate == null) forceUpdate = false;
		var _g = 0;
		var _g1 = this.views;
		while(_g < _g1.length) {
			var view1 = _g1[_g];
			++_g;
			if(this.isComponentArrayEqual(view1.registeredComponents,components)) return view1;
		}
		var view = new glaze_eco_core_View(components);
		this.views.push(view);
		var _g2 = 0;
		while(_g2 < components.length) {
			var component = components[_g2];
			++_g2;
			var name = Reflect.field(component,"NAME");
			var tmp;
			var _this = this.componentViewMap;
			if(__map_reserved[name] != null) tmp = _this.existsReserved(name); else tmp = _this.h.hasOwnProperty(name);
			if(!tmp) {
				var value = [];
				var _this1 = this.componentViewMap;
				if(__map_reserved[name] != null) _this1.setReserved(name,value); else _this1.h[name] = value;
			}
			var tmp1;
			var _this2 = this.componentViewMap;
			if(__map_reserved[name] != null) tmp1 = _this2.getReserved(name); else tmp1 = _this2.h[name];
			tmp1.push(view);
		}
		if(forceUpdate == true) this.matchAllEntitiesToView(this.engine.entities,view);
		return view;
	}
	,releaseView: function(view) {
	}
	,isComponentArrayEqual: function(a,b) {
		if(a.length != b.length) return false;
		var _g = 0;
		while(_g < a.length) {
			var component = a[_g];
			++_g;
			if(HxOverrides.indexOf(b,component,0) < 0) return false;
		}
		return true;
	}
	,entityMatchesView: function(entity,viewSignature) {
		var count = viewSignature.length;
		var _g = 0;
		while(_g < viewSignature.length) {
			var componentClass = viewSignature[_g];
			++_g;
			var tmp;
			var key = Reflect.field(componentClass,"NAME");
			tmp = Object.prototype.hasOwnProperty.call(entity.map,key);
			if(tmp) {
				if(--count == 0) return true;
			}
		}
		return false;
	}
	,matchViews: function(entity,component) {
		var name = Reflect.field(component == null?null:js_Boot.getClass(component),"NAME");
		var tmp;
		var _this = this.componentViewMap;
		if(__map_reserved[name] != null) tmp = _this.getReserved(name); else tmp = _this.h[name];
		var views = tmp;
		if(views != null) {
			var _g = 0;
			while(_g < views.length) {
				var view = views[_g];
				++_g;
				if(this.entityMatchesView(entity,view.registeredComponents)) view.addEntity(entity);
			}
		}
	}
	,matchAllEntitiesToView: function(entities,view) {
		var _g = 0;
		while(_g < entities.length) {
			var entity = entities[_g];
			++_g;
			if(this.entityMatchesView(entity,view.registeredComponents)) view.addEntity(entity);
		}
	}
	,unmatchViews: function(entity,component) {
		var name = Reflect.field(component == null?null:js_Boot.getClass(component),"NAME");
		var tmp;
		var _this = this.componentViewMap;
		if(__map_reserved[name] != null) tmp = _this.getReserved(name); else tmp = _this.h[name];
		var views = tmp;
		if(views != null) {
			var _g = 0;
			while(_g < views.length) {
				var view = views[_g];
				++_g;
				view.removeEntity(entity);
			}
		}
	}
	,injectView: function(system) {
		var view = this.getView(system.registeredComponents);
		view.entityAdded.add($bind(system,system.entityAdded));
		view.entityRemoved.add($bind(system,system.entityRemoved));
		system.view = view;
		if(system.view.entities.length == 0) this.matchAllEntitiesToView(this.engine.entities,view);
	}
	,__class__: glaze_eco_core_ViewManager
};
var glaze_engine_actions_LogAction = function() {
	glaze_ai_behaviortree_Behavior.call(this);
};
glaze_engine_actions_LogAction.__name__ = ["glaze","engine","actions","LogAction"];
glaze_engine_actions_LogAction.__super__ = glaze_ai_behaviortree_Behavior;
glaze_engine_actions_LogAction.prototype = $extend(glaze_ai_behaviortree_Behavior.prototype,{
	update: function(context) {
		console.log("tick");
		return glaze_ai_behaviortree_BehaviorStatus.Running;
	}
	,__class__: glaze_engine_actions_LogAction
});
var glaze_engine_components_Display = function(textureID) {
	this.textureID = textureID;
};
glaze_engine_components_Display.__name__ = ["glaze","engine","components","Display"];
glaze_engine_components_Display.__interfaces__ = [glaze_eco_core_IComponent];
glaze_engine_components_Display.prototype = {
	__class__: glaze_engine_components_Display
};
var glaze_engine_components_ParticleEmitters = function(emitters) {
	this.emitters = emitters;
};
glaze_engine_components_ParticleEmitters.__name__ = ["glaze","engine","components","ParticleEmitters"];
glaze_engine_components_ParticleEmitters.__interfaces__ = [glaze_eco_core_IComponent];
glaze_engine_components_ParticleEmitters.prototype = {
	__class__: glaze_engine_components_ParticleEmitters
};
var glaze_engine_components_Physics = function(width,height,material) {
	this.body = new glaze_physics_Body(width,height,material);
};
glaze_engine_components_Physics.__name__ = ["glaze","engine","components","Physics"];
glaze_engine_components_Physics.__interfaces__ = [glaze_eco_core_IComponent];
glaze_engine_components_Physics.prototype = {
	__class__: glaze_engine_components_Physics
};
var glaze_engine_components_Position = function(x,y) {
	this.coords = new glaze_geom_Vector2(x,y);
};
glaze_engine_components_Position.__name__ = ["glaze","engine","components","Position"];
glaze_engine_components_Position.__interfaces__ = [glaze_eco_core_IComponent];
glaze_engine_components_Position.prototype = {
	__class__: glaze_engine_components_Position
};
var glaze_engine_components_Script = function(behavior) {
	this.behavior = behavior;
};
glaze_engine_components_Script.__name__ = ["glaze","engine","components","Script"];
glaze_engine_components_Script.__interfaces__ = [glaze_eco_core_IComponent];
glaze_engine_components_Script.prototype = {
	__class__: glaze_engine_components_Script
};
var glaze_engine_systems_BehaviourSystem = function() {
	glaze_eco_core_System.call(this,[glaze_engine_components_Script]);
};
glaze_engine_systems_BehaviourSystem.__name__ = ["glaze","engine","systems","BehaviourSystem"];
glaze_engine_systems_BehaviourSystem.__super__ = glaze_eco_core_System;
glaze_engine_systems_BehaviourSystem.prototype = $extend(glaze_eco_core_System.prototype,{
	entityAdded: function(entity) {
		var tmp;
		var value = entity.map.Script;
		if((value instanceof glaze_engine_components_Script)) tmp = value; else tmp = null;
		var script = tmp;
		script.context = new glaze_ai_behaviortree_BehaviorContext(entity);
	}
	,entityRemoved: function(entity) {
	}
	,update: function(timestamp,delta) {
		var _g = 0;
		var _g1 = this.view.entities;
		while(_g < _g1.length) {
			var entity = _g1[_g];
			++_g;
			var tmp;
			var value = entity.map.Script;
			if((value instanceof glaze_engine_components_Script)) tmp = value; else tmp = null;
			var script = tmp;
			script.behavior.tick(script.context);
		}
	}
	,__class__: glaze_engine_systems_BehaviourSystem
});
var glaze_engine_systems_ParticleSystem = function(particleEngine) {
	glaze_eco_core_System.call(this,[glaze_engine_components_Position,glaze_engine_components_ParticleEmitters]);
	this.particleEngine = particleEngine;
};
glaze_engine_systems_ParticleSystem.__name__ = ["glaze","engine","systems","ParticleSystem"];
glaze_engine_systems_ParticleSystem.__super__ = glaze_eco_core_System;
glaze_engine_systems_ParticleSystem.prototype = $extend(glaze_eco_core_System.prototype,{
	entityAdded: function(entity) {
	}
	,entityRemoved: function(entity) {
	}
	,update: function(timestamp,delta) {
		var _g = 0;
		var _g1 = this.view.entities;
		while(_g < _g1.length) {
			var entity = _g1[_g];
			++_g;
			var _g2 = 0;
			var tmp;
			var value = entity.map.ParticleEmitters;
			if((value instanceof glaze_engine_components_ParticleEmitters)) tmp = value; else tmp = null;
			var _g3 = tmp.emitters;
			while(_g2 < _g3.length) {
				var emitter = _g3[_g2];
				++_g2;
				var tmp1;
				var value1 = entity.map.Position;
				if((value1 instanceof glaze_engine_components_Position)) tmp1 = value1; else tmp1 = null;
				emitter.update(timestamp,tmp1.coords,this.particleEngine);
			}
		}
		this.particleEngine.Update();
	}
	,__class__: glaze_engine_systems_ParticleSystem
});
var glaze_engine_systems_RenderSystem = function(canvas) {
	glaze_eco_core_System.call(this,[glaze_engine_components_Position,glaze_engine_components_Display]);
	this.canvas = canvas;
	this.initalizeWebGlRenderer();
};
glaze_engine_systems_RenderSystem.__name__ = ["glaze","engine","systems","RenderSystem"];
glaze_engine_systems_RenderSystem.__super__ = glaze_eco_core_System;
glaze_engine_systems_RenderSystem.prototype = $extend(glaze_eco_core_System.prototype,{
	initalizeWebGlRenderer: function() {
		this.stage = new glaze_render_display_Stage();
		this.camera = new glaze_render_display_Camera();
		this.camera.worldExtentsAABB = new glaze_geom_AABB2(0,4096,4096,0);
		this.camera.worldExtentsAABB.expand(-16);
		this.stage.addChild(this.camera);
		this.renderer = new glaze_render_renderers_webgl_WebGLRenderer(this.stage,this.camera,this.canvas,800,600);
		this.camera.Resize(this.renderer.width,this.renderer.height);
		this.textureManager = new glaze_render_texture_TextureManager(this.renderer.gl);
		this.itemContainer = new glaze_render_display_DisplayObjectContainer();
		this.itemContainer.id = "itemContainer";
		this.camera.addChild(this.itemContainer);
	}
	,entityAdded: function(entity) {
		var tmp;
		var value = entity.map.Position;
		if((value instanceof glaze_engine_components_Position)) tmp = value; else tmp = null;
		var position = tmp;
		var tmp1;
		var value1 = entity.map.Display;
		if((value1 instanceof glaze_engine_components_Display)) tmp1 = value1; else tmp1 = null;
		var display = tmp1;
		display.displayObject = this.createSprite("",display.textureID);
		display.displayObject.position = position.coords;
		this.itemContainer.addChild(display.displayObject);
	}
	,entityRemoved: function(entity) {
		var tmp;
		var value = entity.map.Display;
		if((value instanceof glaze_engine_components_Display)) tmp = value; else tmp = null;
		var display = tmp;
		this.itemContainer.removeChild(display.displayObject);
	}
	,update: function(timestamp,delta) {
		this.camera.Focus(this.cameraTarget.x,this.cameraTarget.y);
		this.renderer.Render(this.camera.viewPortAABB);
	}
	,CameraTarget: function(target) {
		this.cameraTarget = target;
	}
	,createSprite: function(id,tid) {
		var s = new glaze_render_display_Sprite();
		s.id = id;
		var tmp;
		var _this = this.textureManager.textures;
		if(__map_reserved[tid] != null) tmp = _this.getReserved(tid); else tmp = _this.h[tid];
		s.texture = tmp;
		s.position.x = 0;
		s.position.y = 0;
		s.pivot.x = s.texture.frame.width * s.texture.pivot.x;
		s.pivot.y = s.texture.frame.height * s.texture.pivot.y;
		return s;
	}
	,__class__: glaze_engine_systems_RenderSystem
});
var glaze_geom_AABB = function() {
	this.extents = new glaze_geom_Vector2();
	this.position = new glaze_geom_Vector2();
};
glaze_geom_AABB.__name__ = ["glaze","geom","AABB"];
glaze_geom_AABB.prototype = {
	get_l: function() {
		return this.position.x - this.extents.x;
	}
	,get_t: function() {
		return this.position.y - this.extents.y;
	}
	,get_r: function() {
		return this.position.x + this.extents.x;
	}
	,get_b: function() {
		return this.position.y + this.extents.y;
	}
	,overlap: function(aabb) {
		if(Math.abs(this.position.x - aabb.position.x) > this.extents.x + aabb.extents.x) return false;
		if(Math.abs(this.position.y - aabb.position.y) > this.extents.y + aabb.extents.y) return false;
		return true;
	}
	,containsAABB: function(aabb) {
		return false;
	}
	,containsPoint: function(point) {
		return Math.abs(point.x - this.position.x) < this.extents.x && Math.abs(point.y - this.position.y) < this.extents.y;
	}
	,overlapArea: function(aabb) {
		var _l = Math.max(this.position.x - this.extents.x,aabb.position.x - aabb.extents.x);
		var _r = Math.min(this.position.x + this.extents.x,aabb.position.x + aabb.extents.x);
		var _t = Math.max(this.position.y - this.extents.y,aabb.position.y - aabb.extents.y);
		var _b = Math.min(this.position.y + this.extents.y,aabb.position.y + aabb.extents.y);
		return (_r - _l) * (_b - _t);
	}
	,clone: function(aabb) {
		var aabb1 = new glaze_geom_AABB();
		var _this = aabb1.position;
		var v = this.position;
		_this.x = v.x;
		_this.y = v.y;
		var _this1 = aabb1.extents;
		var v1 = this.extents;
		_this1.x = v1.x;
		_this1.y = v1.y;
		return aabb1;
	}
	,__class__: glaze_geom_AABB
};
var glaze_geom_AABB2 = function(t,r,b,l) {
	if(l == null) l = .0;
	if(b == null) b = .0;
	if(r == null) r = .0;
	if(t == null) t = .0;
	this.b = -Infinity;
	this.r = -Infinity;
	this.t = Infinity;
	this.l = Infinity;
	this.t = t;
	this.r = r;
	this.b = b;
	this.l = l;
};
glaze_geom_AABB2.__name__ = ["glaze","geom","AABB2"];
glaze_geom_AABB2.prototype = {
	setToSweeptAABB: function(aabb,preditcedPosition) {
		this.l = aabb.position.x - aabb.extents.x;
		this.r = aabb.position.x + aabb.extents.x;
		this.t = aabb.position.y - aabb.extents.y;
		this.b = aabb.position.y + aabb.extents.y;
	}
	,fromAABB: function(aabb) {
	}
	,clone: function() {
		return new glaze_geom_AABB2(this.t,this.r,this.b,this.l);
	}
	,reset: function() {
		this.t = this.l = Infinity;
		this.r = this.b = -Infinity;
	}
	,get_width: function() {
		return this.r - this.l;
	}
	,get_height: function() {
		return this.b - this.t;
	}
	,intersect: function(aabb) {
		if(this.l > aabb.r) return false; else if(this.r < aabb.l) return false; else if(this.t > aabb.b) return false; else if(this.b < aabb.t) return false; else return true;
	}
	,addAABB: function(aabb) {
		if(aabb.t < this.t) this.t = aabb.t;
		if(aabb.r > this.r) this.r = aabb.r;
		if(aabb.b > this.b) this.b = aabb.b;
		if(aabb.l < this.l) this.l = aabb.l;
	}
	,addPoint: function(x,y) {
		if(x < this.l) this.l = x;
		if(x > this.r) this.r = x;
		if(y < this.t) this.t = y;
		if(y > this.b) this.b = y;
	}
	,fitPoint: function(point) {
		if(point.x < this.l) point.x = this.l;
		if(point.x > this.r) point.x = this.r;
		if(point.y < this.t) point.y = this.t;
		if(point.y > this.b) point.y = this.b;
	}
	,expand: function(i) {
		this.l += i / 2;
		this.r -= i / 2;
		this.t += i / 2;
		this.b -= i / 2;
	}
	,expand2: function(width,height) {
		this.l += width / 2;
		this.r -= width / 2;
		this.t += height / 2;
		this.b -= height / 2;
	}
	,__class__: glaze_geom_AABB2
};
var glaze_geom_Matrix3 = function() { };
glaze_geom_Matrix3.__name__ = ["glaze","geom","Matrix3"];
glaze_geom_Matrix3.Create = function() {
	return glaze_geom_Matrix3.Identity(new Float32Array(9));
};
glaze_geom_Matrix3.Identity = function(matrix) {
	matrix[0] = 1;
	matrix[1] = 0;
	matrix[2] = 0;
	matrix[3] = 0;
	matrix[4] = 1;
	matrix[5] = 0;
	matrix[6] = 0;
	matrix[7] = 0;
	matrix[8] = 1;
	return matrix;
};
glaze_geom_Matrix3.Multiply = function(mat,mat2,dest) {
	if(dest != null) dest = mat;
	var a00 = mat[0];
	var a01 = mat[1];
	var a02 = mat[2];
	var a10 = mat[3];
	var a11 = mat[4];
	var a12 = mat[5];
	var a20 = mat[6];
	var a21 = mat[7];
	var a22 = mat[8];
	var b00 = mat2[0];
	var b01 = mat2[1];
	var b02 = mat2[2];
	var b10 = mat2[3];
	var b11 = mat2[4];
	var b12 = mat2[5];
	var b20 = mat2[6];
	var b21 = mat2[7];
	var b22 = mat2[8];
	dest[0] = b00 * a00 + b01 * a10 + b02 * a20;
	dest[1] = b00 * a01 + b01 * a11 + b02 * a21;
	dest[2] = b00 * a02 + b01 * a12 + b02 * a22;
	dest[3] = b10 * a00 + b11 * a10 + b12 * a20;
	dest[4] = b10 * a01 + b11 * a11 + b12 * a21;
	dest[5] = b10 * a02 + b11 * a12 + b12 * a22;
	dest[6] = b20 * a00 + b21 * a10 + b22 * a20;
	dest[7] = b20 * a01 + b21 * a11 + b22 * a21;
	dest[8] = b20 * a02 + b21 * a12 + b22 * a22;
	return dest;
};
glaze_geom_Matrix3.Clone = function(mat) {
	var matrix = new Float32Array(9);
	matrix[0] = mat[0];
	matrix[1] = mat[1];
	matrix[2] = mat[2];
	matrix[3] = mat[3];
	matrix[4] = mat[4];
	matrix[5] = mat[5];
	matrix[6] = mat[6];
	matrix[7] = mat[7];
	matrix[8] = mat[8];
	return matrix;
};
glaze_geom_Matrix3.Transpose = function(mat,dest) {
	if(dest != null || mat == dest) {
		var a01 = mat[1];
		var a02 = mat[2];
		var a12 = mat[5];
		mat[1] = mat[3];
		mat[2] = mat[6];
		mat[3] = a01;
		mat[5] = mat[7];
		mat[6] = a02;
		mat[7] = a12;
		return mat;
	}
	dest[0] = mat[0];
	dest[1] = mat[3];
	dest[2] = mat[6];
	dest[3] = mat[1];
	dest[4] = mat[4];
	dest[5] = mat[7];
	dest[6] = mat[2];
	dest[7] = mat[5];
	dest[8] = mat[8];
	return dest;
};
glaze_geom_Matrix3.ToMatrix4 = function(mat,dest) {
	if(dest == null) dest = glaze_geom_Matrix4.Create();
	dest[15] = 1;
	dest[14] = 0;
	dest[13] = 0;
	dest[12] = 0;
	dest[11] = 0;
	dest[10] = mat[8];
	dest[9] = mat[7];
	dest[8] = mat[6];
	dest[7] = 0;
	dest[6] = mat[5];
	dest[5] = mat[4];
	dest[4] = mat[3];
	dest[3] = 0;
	dest[2] = mat[2];
	dest[1] = mat[1];
	dest[0] = mat[0];
	return dest;
};
var glaze_geom_Matrix4 = function() { };
glaze_geom_Matrix4.__name__ = ["glaze","geom","Matrix4"];
glaze_geom_Matrix4.Create = function() {
	return glaze_geom_Matrix4.Identity(new Float32Array(16));
};
glaze_geom_Matrix4.Identity = function(matrix) {
	matrix[0] = 1;
	matrix[1] = 0;
	matrix[2] = 0;
	matrix[3] = 0;
	matrix[4] = 0;
	matrix[5] = 1;
	matrix[6] = 0;
	matrix[7] = 0;
	matrix[8] = 0;
	matrix[9] = 0;
	matrix[10] = 1;
	matrix[11] = 0;
	matrix[12] = 0;
	matrix[13] = 0;
	matrix[14] = 0;
	matrix[15] = 1;
	return matrix;
};
glaze_geom_Matrix4.Transpose = function(mat,dest) {
	if(dest != null || mat == dest) {
		var a01 = mat[1];
		var a02 = mat[2];
		var a03 = mat[3];
		var a12 = mat[6];
		var a13 = mat[7];
		var a23 = mat[11];
		mat[1] = mat[4];
		mat[2] = mat[8];
		mat[3] = mat[12];
		mat[4] = a01;
		mat[6] = mat[9];
		mat[7] = mat[13];
		mat[8] = a02;
		mat[9] = a12;
		mat[11] = mat[14];
		mat[12] = a03;
		mat[13] = a13;
		mat[14] = a23;
		return mat;
	}
	dest[0] = mat[0];
	dest[1] = mat[4];
	dest[2] = mat[8];
	dest[3] = mat[12];
	dest[4] = mat[1];
	dest[5] = mat[5];
	dest[6] = mat[9];
	dest[7] = mat[13];
	dest[8] = mat[2];
	dest[9] = mat[6];
	dest[10] = mat[10];
	dest[11] = mat[14];
	dest[12] = mat[3];
	dest[13] = mat[7];
	dest[14] = mat[11];
	dest[15] = mat[15];
	return dest;
};
glaze_geom_Matrix4.Multiply = function(mat,mat2,dest) {
	if(dest != null) dest = mat;
	var a00 = mat[0];
	var a01 = mat[1];
	var a02 = mat[2];
	var a03 = mat[3];
	var a10 = mat[4];
	var a11 = mat[5];
	var a12 = mat[6];
	var a13 = mat[7];
	var a20 = mat[8];
	var a21 = mat[9];
	var a22 = mat[10];
	var a23 = mat[11];
	var a30 = mat[12];
	var a31 = mat[13];
	var a32 = mat[14];
	var a33 = mat[15];
	var b0 = mat2[0];
	var b1 = mat2[1];
	var b2 = mat2[2];
	var b3 = mat2[3];
	dest[0] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
	dest[1] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
	dest[2] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
	dest[3] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;
	b0 = mat2[4];
	b1 = mat2[5];
	b2 = mat2[6];
	b3 = mat2[7];
	dest[4] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
	dest[5] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
	dest[6] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
	dest[7] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;
	b0 = mat2[8];
	b1 = mat2[9];
	b2 = mat2[10];
	b3 = mat2[11];
	dest[8] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
	dest[9] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
	dest[10] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
	dest[11] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;
	b0 = mat2[12];
	b1 = mat2[13];
	b2 = mat2[14];
	b3 = mat2[15];
	dest[12] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
	dest[13] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
	dest[14] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
	dest[15] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;
	return dest;
};
var glaze_geom_Plane = function() {
	this.d = 0;
	this.n = new glaze_geom_Vector2();
};
glaze_geom_Plane.__name__ = ["glaze","geom","Plane"];
glaze_geom_Plane.prototype = {
	set: function(n,q) {
		var _this = this.n;
		_this.x = n.x;
		_this.y = n.y;
		var tmp;
		var _this1 = this.n;
		tmp = _this1.x * q.x + _this1.y * q.y;
		this.d = tmp;
	}
	,setFromSegment: function(s,e) {
		var _this = this.n;
		_this.x = s.x;
		_this.y = s.y;
		var _this1 = this.n;
		_this1.x -= e.x;
		_this1.y -= e.y;
		this.n.normalize();
		this.n.leftHandNormalEquals();
		var tmp;
		var _this2 = this.n;
		tmp = _this2.x * s.x + _this2.y * s.y;
		this.d = tmp;
	}
	,distancePoint: function(q) {
		var tmp;
		var _this = this.n;
		tmp = _this.x * q.x + _this.y * q.y;
		return tmp - this.d;
	}
	,__class__: glaze_geom_Plane
};
var glaze_geom_Rectangle = function(x,y,width,height) {
	if(height == null) height = 0.;
	if(width == null) width = 0.;
	if(y == null) y = 0.;
	if(x == null) x = 0.;
	this.x = x;
	this.y = y;
	this.width = width;
	this.height = height;
};
glaze_geom_Rectangle.__name__ = ["glaze","geom","Rectangle"];
glaze_geom_Rectangle.prototype = {
	__class__: glaze_geom_Rectangle
};
var glaze_geom_Vector2 = function(x,y) {
	if(y == null) y = .0;
	if(x == null) x = .0;
	this.x = x;
	this.y = y;
};
glaze_geom_Vector2.__name__ = ["glaze","geom","Vector2"];
glaze_geom_Vector2.prototype = {
	setTo: function(x,y) {
		this.x = x;
		this.y = y;
	}
	,copy: function(v) {
		this.x = v.x;
		this.y = v.y;
	}
	,clone: function() {
		return new glaze_geom_Vector2(this.x,this.y);
	}
	,normalize: function() {
		var t = Math.sqrt(this.x * this.x + this.y * this.y) + 1e-08;
		this.x /= t;
		this.y /= t;
		return t;
	}
	,length: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}
	,clampScalar: function(max) {
		var l = Math.sqrt(this.x * this.x + this.y * this.y);
		if(l > max) {
			var s = max / l;
			this.x *= s;
			this.y *= s;
		}
	}
	,clampVector: function(v) {
		this.x = Math.min(Math.max(this.x,-v.x),v.x);
		this.y = Math.min(Math.max(this.y,-v.y),v.y);
	}
	,plusEquals: function(v) {
		this.x += v.x;
		this.y += v.y;
	}
	,minusEquals: function(v) {
		this.x -= v.x;
		this.y -= v.y;
	}
	,multEquals: function(s) {
		this.x *= s;
		this.y *= s;
	}
	,plusMultEquals: function(v,s) {
		this.x += v.x * s;
		this.y += v.y * s;
	}
	,minusMultEquals: function(v,s) {
		this.x -= v.x * s;
		this.y -= v.y * s;
	}
	,dot: function(v) {
		return this.x * v.x + this.y * v.y;
	}
	,cross: function(v) {
		return this.x * v.y - this.y * v.x;
	}
	,leftHandNormal: function() {
		return new glaze_geom_Vector2(this.y,-this.x);
	}
	,leftHandNormalEquals: function() {
		var t = this.x;
		this.x = this.y;
		this.y = -t;
	}
	,rightHandNormal: function() {
		return new glaze_geom_Vector2(-this.y,this.x);
	}
	,reflectEquals: function(normal) {
		var d = this.x * normal.x + this.y * normal.y;
		this.x -= 2 * d * normal.x;
		this.y -= 2 * d * normal.y;
	}
	,__class__: glaze_geom_Vector2
};
var glaze_particle_BlockSpriteParticle = function() {
};
glaze_particle_BlockSpriteParticle.__name__ = ["glaze","particle","BlockSpriteParticle"];
glaze_particle_BlockSpriteParticle.prototype = {
	Initalize: function(x,y,vX,vY,fX,fY,ttl,damping,decay,top,externalForce,data1,data2,data3,data4,data5) {
		this.pX = x;
		this.pY = y;
		this.vX = vX;
		this.vY = vY;
		this.fX = fX;
		this.fY = fY;
		this.ttl = ttl;
		this.age = ttl;
		this.damping = damping;
		this.decay = decay;
		this.externalForce = externalForce;
		this.size = data1;
		this.alpha = data2 * 0.00392156862745098;
		this.red = data3;
		this.green = data4;
		this.blue = data5;
	}
	,Update: function(deltaTime,invDeltaTime) {
		this.vX += this.fX + this.externalForce.x;
		this.vY += this.fY + this.externalForce.y;
		this.vX *= this.damping;
		this.vY *= this.damping;
		this.pX += this.vX * invDeltaTime;
		this.pY += this.vY * invDeltaTime;
		this.age -= deltaTime;
		this.alpha -= this.decay;
		return this.age > 0;
	}
	,__class__: glaze_particle_BlockSpriteParticle
};
var glaze_particle_IParticleEngine = function() { };
glaze_particle_IParticleEngine.__name__ = ["glaze","particle","IParticleEngine"];
glaze_particle_IParticleEngine.prototype = {
	__class__: glaze_particle_IParticleEngine
};
var glaze_particle_BlockSpriteParticleEngine = function(particleCount,deltaTime) {
	this.particleCount = particleCount;
	this.deltaTime = deltaTime;
	this.invDeltaTime = deltaTime / 1000;
	this.ZERO_FORCE = new glaze_geom_Vector2();
	var _g = 0;
	while(_g < particleCount) {
		_g++;
		var p = new glaze_particle_BlockSpriteParticle();
		p.next = this.cachedParticles;
		this.cachedParticles = p;
	}
	this.renderer = new glaze_render_renderers_webgl_PointSpriteLightMapRenderer();
	this.renderer.ResizeBatch(particleCount);
};
glaze_particle_BlockSpriteParticleEngine.__name__ = ["glaze","particle","BlockSpriteParticleEngine"];
glaze_particle_BlockSpriteParticleEngine.__interfaces__ = [glaze_particle_IParticleEngine];
glaze_particle_BlockSpriteParticleEngine.prototype = {
	EmitParticle: function(x,y,vX,vY,fX,fY,ttl,damping,decayable,top,externalForce,data1,data2,data3,data4,data5) {
		if(this.cachedParticles == null) return false;
		var particle = this.cachedParticles;
		this.cachedParticles = this.cachedParticles.next;
		if(this.activeParticles == null) {
			this.activeParticles = particle;
			particle.next = particle.prev = null;
		} else {
			particle.next = this.activeParticles;
			particle.prev = null;
			this.activeParticles.prev = particle;
			this.activeParticles = particle;
		}
		particle.pX = x;
		particle.pY = y;
		particle.vX = vX;
		particle.vY = vY;
		particle.fX = fX;
		particle.fY = fY;
		particle.ttl = ttl;
		particle.age = ttl;
		particle.damping = damping;
		particle.decay = decayable?this.deltaTime / ttl:0;
		particle.externalForce = externalForce != null?externalForce:this.ZERO_FORCE;
		particle.size = data1;
		particle.alpha = data2 * 0.00392156862745098;
		particle.red = data3;
		particle.green = data4;
		particle.blue = data5;
		return true;
	}
	,Update: function() {
		this.renderer.ResetBatch();
		var particle = this.activeParticles;
		while(particle != null) {
			var tmp;
			var invDeltaTime = this.invDeltaTime;
			particle.vX += particle.fX + particle.externalForce.x;
			particle.vY += particle.fY + particle.externalForce.y;
			particle.vX *= particle.damping;
			particle.vY *= particle.damping;
			particle.pX += particle.vX * invDeltaTime;
			particle.pY += particle.vY * invDeltaTime;
			particle.age -= this.deltaTime;
			particle.alpha -= particle.decay;
			tmp = particle.age > 0;
			if(!tmp) {
				var next = particle.next;
				if(particle.prev == null) this.activeParticles = particle.next; else particle.prev.next = particle.next;
				if(particle.next != null) particle.next.prev = particle.prev;
				particle.next = this.cachedParticles;
				this.cachedParticles = particle;
				particle = next;
			} else {
				this.renderer.AddSpriteToBatch(particle.pX,particle.pY,particle.size,particle.alpha * 255 | 0,particle.red,particle.green,particle.blue);
				particle = particle.next;
			}
		}
	}
	,__class__: glaze_particle_BlockSpriteParticleEngine
};
var glaze_particle_emitter_IParticleEmitter = function() { };
glaze_particle_emitter_IParticleEmitter.__name__ = ["glaze","particle","emitter","IParticleEmitter"];
glaze_particle_emitter_IParticleEmitter.prototype = {
	__class__: glaze_particle_emitter_IParticleEmitter
};
var glaze_particle_emitter_RandomSpray = function(rate,speed) {
	this.rate = rate;
	this.speed = speed;
};
glaze_particle_emitter_RandomSpray.__name__ = ["glaze","particle","emitter","RandomSpray"];
glaze_particle_emitter_RandomSpray.__interfaces__ = [glaze_particle_emitter_IParticleEmitter];
glaze_particle_emitter_RandomSpray.prototype = {
	update: function(time,position,engine) {
		var angle = Math.random() * (2 * Math.PI);
		var vx = Math.cos(angle) * this.speed;
		var vy = Math.sin(angle) * this.speed;
		engine.EmitParticle(position.x,position.y,vx,vy,0,0,800,0.99,true,true,null,4,255,255,255,255);
	}
	,__class__: glaze_particle_emitter_RandomSpray
};
var glaze_physics_Body = function(w,h,material,filter) {
	this.debug = 0;
	this.bounceCount = 0;
	this.totalBounceCount = 0;
	this.onGroundPrev = false;
	this.onGround = false;
	this.dt = 0;
	this.invMass = 1;
	this.mass = 1;
	this.damping = 1;
	this.isBullet = false;
	this.accumulatedForces = new glaze_geom_Vector2();
	this.forces = new glaze_geom_Vector2();
	this.bfproxy = new glaze_physics_collision_BFProxy();
	this.aabb = new glaze_geom_AABB();
	this.maxVelocity = new glaze_geom_Vector2();
	this.maxScalarVelocity = 1000;
	this.stepContactCount = 0;
	this.lastNormal = new glaze_geom_Vector2();
	this.originalVelocity = new glaze_geom_Vector2();
	this.velocity = new glaze_geom_Vector2();
	this.previousPosition = new glaze_geom_Vector2();
	this.delta = new glaze_geom_Vector2();
	this.predictedPosition = new glaze_geom_Vector2();
	this.positionCorrection = new glaze_geom_Vector2();
	this.position = new glaze_geom_Vector2();
	var _this = this.aabb.extents;
	_this.x = w;
	_this.y = h;
	this.material = material;
	this.filter = filter;
	this.aabb.position = this.position;
	this.setMass(1);
	this.bfproxy.body = this;
	this.bfproxy.filter = this.filter;
	this.bfproxy.aabb = this.aabb;
	this.bfproxy.isStatic = false;
};
glaze_physics_Body.__name__ = ["glaze","physics","Body"];
glaze_physics_Body.prototype = {
	update: function(dt,globalForces,globalDamping) {
		this.dt = dt;
		var _this = this.forces;
		_this.x += globalForces.x;
		_this.y += globalForces.y;
		var _this1 = this.velocity;
		var v = this.forces;
		_this1.x += v.x;
		_this1.y += v.y;
		var _this2 = this.velocity;
		var s = globalDamping * this.damping;
		_this2.x *= s;
		_this2.y *= s;
		if(!this.isBullet) {
			if(this.maxScalarVelocity > 0) this.velocity.clampScalar(this.maxScalarVelocity); else {
				var _this3 = this.velocity;
				var v1 = this.maxVelocity;
				_this3.x = Math.min(Math.max(_this3.x,-v1.x),v1.x);
				_this3.y = Math.min(Math.max(_this3.y,-v1.y),v1.y);
			}
		}
		var _this4 = this.originalVelocity;
		var v2 = this.velocity;
		_this4.x = v2.x;
		_this4.y = v2.y;
		var _this5 = this.predictedPosition;
		var v3 = this.position;
		_this5.x = v3.x;
		_this5.y = v3.y;
		var _this6 = this.predictedPosition;
		var v4 = this.velocity;
		_this6.x += v4.x * dt;
		_this6.y += v4.y * dt;
		var _this7 = this.previousPosition;
		var v5 = this.position;
		_this7.x = v5.x;
		_this7.y = v5.y;
		var _this8 = this.delta;
		var v6 = this.predictedPosition;
		_this8.x = v6.x;
		_this8.y = v6.y;
		var _this9 = this.delta;
		var v7 = this.position;
		_this9.x -= v7.x;
		_this9.y -= v7.y;
		var _this10 = this.forces;
		_this10.x = 0;
		_this10.y = 0;
		this.damping = 1;
		this.onGroundPrev = this.onGround;
		this.onGround = false;
		this.stepContactCount = 0;
		this.toi = Infinity;
	}
	,respondStaticCollision: function(contact) {
		var seperation = Math.max(contact.distance,0);
		var penetration = Math.min(contact.distance,0);
		var _this = this.positionCorrection;
		var v = contact.normal;
		var s = penetration / this.dt;
		_this.x -= v.x * s;
		_this.y -= v.y * s;
		var tmp;
		var _this1 = this.velocity;
		var v1 = contact.normal;
		tmp = _this1.x * v1.x + _this1.y * v1.y;
		var nv = tmp + seperation / this.dt;
		if(nv < 0) {
			this.stepContactCount++;
			var _this2 = this.velocity;
			var v2 = contact.normal;
			_this2.x -= v2.x * nv;
			_this2.y -= v2.y * nv;
			if(!(this.bounceCount != this.totalBounceCount) && contact.normal.y < 0) this.onGround = true;
			var _this3 = this.lastNormal;
			var v3 = contact.normal;
			_this3.x = v3.x;
			_this3.y = v3.y;
			return true;
		}
		return false;
	}
	,t: function(msg) {
		if(this.debug > 0) {
			console.log(msg);
			this.debug--;
		}
	}
	,respondBulletCollision: function(contact) {
		if(contact.time <= this.toi) {
			this.toi = contact.time;
			var _this = this.positionCorrection;
			var v = contact.sweepPosition;
			_this.x = v.x;
			_this.y = v.y;
			var _this1 = this.lastNormal;
			var v1 = contact.normal;
			_this1.x = v1.x;
			_this1.y = v1.y;
			return true;
		}
		return false;
	}
	,updatePosition: function() {
		if(this.isBullet) {
			if(this.toi < Infinity) {
				var _this = this.position;
				var v = this.positionCorrection;
				_this.x = v.x;
				_this.y = v.y;
				this.originalVelocity.reflectEquals(this.lastNormal);
				var _this1 = this.originalVelocity;
				var s = this.material.elasticity;
				_this1.x *= s;
				_this1.y *= s;
				var _this2 = this.velocity;
				var v1 = this.originalVelocity;
				_this2.x = v1.x;
				_this2.y = v1.y;
			} else {
				var _this3 = this.position;
				var v2 = this.predictedPosition;
				_this3.x = v2.x;
				_this3.y = v2.y;
			}
			return;
		}
		if(this.stepContactCount > 0 && !(this.bounceCount != this.totalBounceCount) && this.lastNormal.y < 0) {
			var tangent = this.lastNormal.rightHandNormal();
			var tmp;
			var _this4 = this.originalVelocity;
			tmp = _this4.x * tangent.x + _this4.y * tangent.y;
			var tv = tmp * this.material.friction;
			this.velocity.x -= tangent.x * tv;
			this.velocity.y -= tangent.y * tv;
		}
		var _this5 = this.positionCorrection;
		var v3 = this.velocity;
		_this5.x += v3.x;
		_this5.y += v3.y;
		var _this6 = this.positionCorrection;
		var s1 = this.dt;
		_this6.x *= s1;
		_this6.y *= s1;
		var _this7 = this.position;
		var v4 = this.positionCorrection;
		_this7.x += v4.x;
		_this7.y += v4.y;
		var _this8 = this.positionCorrection;
		_this8.x = 0;
		_this8.y = 0;
		if(this.stepContactCount > 0 && this.bounceCount != this.totalBounceCount) {
			this.originalVelocity.reflectEquals(this.lastNormal);
			var _this9 = this.originalVelocity;
			var s2 = this.material.elasticity;
			_this9.x *= s2;
			_this9.y *= s2;
			var _this10 = this.velocity;
			var v5 = this.originalVelocity;
			_this10.x = v5.x;
			_this10.y = v5.y;
			this.bounceCount++;
		}
	}
	,addForce: function(f) {
		var _this = this.forces;
		var s = this.invMass;
		_this.x += f.x * s;
		_this.y += f.y * s;
	}
	,addMasslessForce: function(f) {
		var _this = this.forces;
		_this.x += f.x;
		_this.y += f.y;
	}
	,setMass: function(mass) {
		this.mass = mass;
		this.invMass = 1 / mass;
	}
	,setBounces: function(count) {
		this.totalBounceCount = count;
		this.bounceCount = 0;
	}
	,get_canBounce: function() {
		return this.bounceCount != this.totalBounceCount;
	}
	,__class__: glaze_physics_Body
};
var glaze_physics_Material = function(density,elasticity,friction) {
	if(friction == null) friction = 0.1;
	if(elasticity == null) elasticity = 0.3;
	if(density == null) density = 1;
	this.density = density;
	this.elasticity = elasticity;
	this.friction = friction;
};
glaze_physics_Material.__name__ = ["glaze","physics","Material"];
glaze_physics_Material.prototype = {
	__class__: glaze_physics_Material
};
var glaze_physics_collision_BFProxy = function() {
	this.contactCallback = null;
	this.isSensor = false;
	this.isStatic = false;
};
glaze_physics_collision_BFProxy.__name__ = ["glaze","physics","collision","BFProxy"];
glaze_physics_collision_BFProxy.CreateStaticFeature = function(x,y,hw,hh) {
	var bfproxy = new glaze_physics_collision_BFProxy();
	bfproxy.aabb = new glaze_geom_AABB();
	var _this = bfproxy.aabb.position;
	_this.x = x;
	_this.y = y;
	var _this1 = bfproxy.aabb.extents;
	_this1.x = hw;
	_this1.y = hh;
	bfproxy.isStatic = true;
	return bfproxy;
};
glaze_physics_collision_BFProxy.prototype = {
	__class__: glaze_physics_collision_BFProxy
};
var glaze_physics_collision_Contact = function() {
	this.sweepPosition = new glaze_geom_Vector2();
	this.time = 0;
	this.distance = 0;
	this.normal = new glaze_geom_Vector2();
	this.delta = new glaze_geom_Vector2();
	this.position = new glaze_geom_Vector2();
};
glaze_physics_collision_Contact.__name__ = ["glaze","physics","collision","Contact"];
glaze_physics_collision_Contact.prototype = {
	setTo: function(contact) {
		this.position.x = contact.position.x;
		this.position.y = contact.position.y;
		this.delta.x = contact.delta.x;
		this.delta.y = contact.delta.y;
		this.normal.x = contact.normal.x;
		this.normal.y = contact.normal.y;
		this.time = contact.time;
		this.distance = contact.distance;
		this.sweepPosition.x = contact.sweepPosition.x;
		this.sweepPosition.y = contact.sweepPosition.y;
	}
	,__class__: glaze_physics_collision_Contact
};
var glaze_physics_collision_Filter = function() {
	this.groupIndex = 0;
	this.maskBits = 65535;
	this.categoryBits = 1;
};
glaze_physics_collision_Filter.__name__ = ["glaze","physics","collision","Filter"];
glaze_physics_collision_Filter.CHECK = function(filterA,filterB) {
	if(filterA == null || filterB == null) return true; else if(filterA.groupIndex > 0 && filterB.groupIndex > 0 && filterA.groupIndex == filterB.groupIndex) return false; else {
		if((filterA.maskBits & filterB.categoryBits) == 0) return false;
		if((filterA.categoryBits & filterB.maskBits) == 0) return false;
	}
	return true;
};
glaze_physics_collision_Filter.prototype = {
	__class__: glaze_physics_collision_Filter
};
var glaze_physics_collision_Intersect = function() {
	this.contact = new glaze_physics_collision_Contact();
};
glaze_physics_collision_Intersect.__name__ = ["glaze","physics","collision","Intersect"];
glaze_physics_collision_Intersect.StaticAABBvsStaticAABB = function(aabb_position_A,aabb_extents_A,aabb_position_B,aabb_extents_B,contact) {
	var dx = aabb_position_B.x - aabb_position_A.x;
	var px = aabb_extents_B.x + aabb_extents_A.x - Math.abs(dx);
	if(px <= 0) return false;
	var dy = aabb_position_B.y - aabb_position_A.y;
	var py = aabb_extents_B.y + aabb_extents_A.y - Math.abs(dy);
	if(py <= 0) return false;
	if(px < py) {
		var sx = dx < 0?-1:1;
		contact.distance = contact.delta.x = px * sx;
		contact.delta.y = 0;
		contact.normal.x = sx;
		contact.normal.y = 0;
		contact.position.x = aabb_position_A.x + aabb_extents_A.x * sx;
		contact.position.y = aabb_position_B.y;
	} else {
		var sy = dy < 0?-1:1;
		contact.delta.x = 0;
		contact.distance = contact.delta.y = py * sy;
		contact.normal.x = 0;
		contact.normal.y = sy;
		contact.position.x = aabb_position_B.x;
		contact.position.y = aabb_position_A.y + aabb_extents_A.y * sy;
	}
	return true;
};
glaze_physics_collision_Intersect.StaticSegmentvsStaticAABB = function(aabb_position,aabb_extents,segment_position,segment_delta,paddingX,paddingY,contact) {
	var scaleX = 1 / segment_delta.x;
	var scaleY = 1 / segment_delta.y;
	var signX = scaleX < 0?-1:1;
	var signY = scaleY < 0?-1:1;
	var nearTimeX = (aabb_position.x - signX * (aabb_extents.x + paddingX) - segment_position.x) * scaleX;
	var nearTimeY = (aabb_position.y - signY * (aabb_extents.y + paddingY) - segment_position.y) * scaleY;
	var farTimeX = (aabb_position.x + signX * (aabb_extents.x + paddingX) - segment_position.x) * scaleX;
	var farTimeY = (aabb_position.y + signY * (aabb_extents.y + paddingY) - segment_position.y) * scaleY;
	if(nearTimeX > farTimeY || nearTimeY > farTimeX) return false;
	var nearTime = Math.max(nearTimeX,nearTimeY);
	var farTime = Math.min(farTimeX,farTimeY);
	if(nearTime >= 1 || farTime <= 0) return false;
	contact.time = Math.min(Math.max(nearTime,0),1);
	if(nearTimeX > nearTimeY) {
		contact.normal.x = -signX;
		contact.normal.y = 0;
	} else {
		contact.normal.x = 0;
		contact.normal.y = -signY;
	}
	contact.delta.x = contact.time * segment_delta.x;
	contact.delta.y = contact.time * segment_delta.y;
	contact.position.x = segment_position.x + contact.delta.x;
	contact.position.y = segment_position.y + contact.delta.y;
	return true;
};
glaze_physics_collision_Intersect.StaticAABBvsSweeptAABB = function(aabb_position_A,aabb_extents_A,aabb_position_B,aabb_extents_B,aabb_delta_B,contact) {
	if(aabb_delta_B.x == 0 && aabb_delta_B.y == 0) {
		contact.sweepPosition.x = aabb_position_B.x;
		contact.sweepPosition.y = aabb_position_B.y;
		if(glaze_physics_collision_Intersect.StaticAABBvsStaticAABB(aabb_position_A,aabb_extents_A,aabb_position_B,aabb_extents_B,contact)) {
			contact.time = 0;
			return true;
		} else {
			contact.time = 1;
			return false;
		}
	} else if(glaze_physics_collision_Intersect.StaticSegmentvsStaticAABB(aabb_position_A,aabb_extents_A,aabb_position_B,aabb_delta_B,aabb_extents_B.x,aabb_extents_B.y,contact)) {
		contact.time = Math.min(Math.max(contact.time - 1e-8,0),1);
		contact.sweepPosition.x = aabb_position_B.x + aabb_delta_B.x * contact.time;
		contact.sweepPosition.y = aabb_position_B.y + aabb_delta_B.y * contact.time;
		var t = Math.sqrt(aabb_delta_B.x * aabb_delta_B.x + aabb_delta_B.y * aabb_delta_B.y);
		contact.position.x += aabb_delta_B.x / t * aabb_extents_B.x;
		contact.position.y += aabb_delta_B.y / t * aabb_extents_B.y;
		return true;
	} else {
		contact.sweepPosition.x = aabb_position_B.x * aabb_delta_B.x;
		contact.sweepPosition.y = aabb_position_B.y * aabb_delta_B.y;
		return false;
	}
};
glaze_physics_collision_Intersect.AABBvsStaticSolidAABB = function(aabb_position_A,aabb_extents_A,aabb_position_B,aabb_extents_B,contact) {
	var dx = aabb_position_B.x - aabb_position_A.x;
	var px = aabb_extents_B.x + aabb_extents_A.x - Math.abs(dx);
	var dy = aabb_position_B.y - aabb_position_A.y;
	var py = aabb_extents_B.y + aabb_extents_A.y - Math.abs(dy);
	if(px < py) {
		contact.normal.x = dx < 0?1:-1;
		contact.normal.y = 0;
	} else {
		contact.normal.x = 0;
		contact.normal.y = dy < 0?1:-1;
	}
	var pcx = contact.normal.x * (aabb_extents_A.x + aabb_extents_B.x) + aabb_position_B.x;
	var pcy = contact.normal.y * (aabb_extents_A.y + aabb_extents_B.y) + aabb_position_B.y;
	var pdx = aabb_position_A.x - pcx;
	var pdy = aabb_position_A.y - pcy;
	contact.distance = pdx * contact.normal.x + pdy * contact.normal.y;
	return true;
};
glaze_physics_collision_Intersect.prototype = {
	Collide: function(proxyA,proxyB) {
		if(proxyA.isStatic && proxyB.isStatic || proxyA.isSensor && proxyB.isSensor) return false;
		if(!glaze_physics_collision_Filter.CHECK(proxyA.filter,proxyB.filter)) return false;
		var collided = false;
		if(proxyA.isSensor || proxyB.isSensor) collided = glaze_physics_collision_Intersect.StaticAABBvsStaticAABB(proxyA.aabb.position,proxyA.aabb.extents,proxyB.aabb.position,proxyB.aabb.extents,this.contact); else if(!proxyA.isStatic && !proxyB.isStatic) {
			if(proxyA.body.isBullet && proxyB.body.isBullet) return false; else if(proxyA.body.isBullet) {
				if(glaze_physics_collision_Intersect.StaticAABBvsSweeptAABB(proxyB.aabb.position,proxyB.aabb.extents,proxyA.aabb.position,proxyA.aabb.extents,proxyA.body.delta,this.contact) == true) {
					proxyA.body.respondBulletCollision(this.contact);
					collided = true;
				}
			} else if(proxyB.body.isBullet) {
				if(glaze_physics_collision_Intersect.StaticAABBvsSweeptAABB(proxyA.aabb.position,proxyA.aabb.extents,proxyB.aabb.position,proxyB.aabb.extents,proxyB.body.delta,this.contact) == true) {
					proxyB.body.respondBulletCollision(this.contact);
					collided = true;
				}
			} else collided = glaze_physics_collision_Intersect.StaticAABBvsStaticAABB(proxyA.aabb.position,proxyA.aabb.extents,proxyB.aabb.position,proxyB.aabb.extents,this.contact);
		} else {
			var staticProxy;
			var dynamicProxy;
			if(proxyA.isStatic) {
				staticProxy = proxyA;
				dynamicProxy = proxyB;
			} else {
				staticProxy = proxyB;
				dynamicProxy = proxyA;
			}
			glaze_physics_collision_Intersect.AABBvsStaticSolidAABB(dynamicProxy.aabb.position,dynamicProxy.aabb.extents,staticProxy.aabb.position,staticProxy.aabb.extents,this.contact);
			collided = dynamicProxy.body.respondStaticCollision(this.contact);
		}
		if(collided == true) {
			if(proxyA.contactCallback != null) proxyA.contactCallback(proxyA,proxyB,this.contact);
			if(proxyB.contactCallback != null) proxyB.contactCallback(proxyB,proxyA,this.contact);
		}
		return collided;
	}
	,RayAABB: function(ray,proxy) {
		if(glaze_physics_collision_Intersect.StaticSegmentvsStaticAABB(proxy.aabb.position,proxy.aabb.extents,ray.origin,ray.delta,0,0,this.contact)) {
			ray.report(this.contact.delta.x,this.contact.delta.y,this.contact.normal.x,this.contact.normal.y,proxy);
			return true;
		}
		return false;
	}
	,Spring: function(bodyA,bodyB,length,k) {
		var dx = bodyA.position.x - bodyB.position.x;
		var dy = bodyA.position.y - bodyB.position.y;
		var dist = Math.sqrt(dx * dx + dy * dy);
		if(dist < length) return;
		var dx_n = dx / dist;
		var dy_n = dy / dist;
		var true_offset = dist - length;
		dx_n *= true_offset;
		dy_n *= true_offset;
		var fx = k * dx_n;
		var fy = k * dy_n;
		bodyA.addForce(new glaze_geom_Vector2(fx,fy));
		bodyB.addForce(new glaze_geom_Vector2(-fx,-fy));
	}
	,__class__: glaze_physics_collision_Intersect
};
var glaze_physics_collision_Map = function(data) {
	this.plane = new glaze_geom_Plane();
	this.tileExtents = new glaze_geom_Vector2();
	this.tilePosition = new glaze_geom_Vector2();
	this.data = data;
	this.tileSize = data.cellSize;
	this.tileHalfSize = this.tileSize / 2;
	var _this = this.tileExtents;
	_this.x = this.tileHalfSize;
	_this.y = this.tileHalfSize;
	this.contact = new glaze_physics_collision_Contact();
};
glaze_physics_collision_Map.__name__ = ["glaze","physics","collision","Map"];
glaze_physics_collision_Map.prototype = {
	testCollision: function(body) {
		var tmp;
		var value = Math.min(body.position.x,body.predictedPosition.x) - body.aabb.extents.x;
		tmp = value * this.data.invCellSize | 0;
		var startX = tmp;
		var tmp1;
		var value1 = Math.min(body.position.y,body.predictedPosition.y) - body.aabb.extents.y;
		tmp1 = value1 * this.data.invCellSize | 0;
		var startY = tmp1;
		var tmp2;
		var value2 = Math.max(body.position.x,body.predictedPosition.x) + body.aabb.extents.x - .01;
		tmp2 = value2 * this.data.invCellSize | 0;
		var endX = tmp2 + 1;
		var tmp3;
		var value3 = Math.max(body.position.y,body.predictedPosition.y) + body.aabb.extents.y;
		tmp3 = value3 * this.data.invCellSize | 0;
		var endY = tmp3 + 1;
		this.plane.setFromSegment(body.predictedPosition,body.position);
		var _g = startX;
		while(_g < endX) {
			var x = _g++;
			var _g1 = startY;
			while(_g1 < endY) {
				var y = _g1++;
				var tmp4;
				var _this = this.data;
				tmp4 = _this.data.b[y * _this.internalWidth + x * _this.bytesPerCell];
				var cell = tmp4;
				if((cell & 1) == 1) {
					this.tilePosition.x = x * this.tileSize + this.tileHalfSize;
					this.tilePosition.y = y * this.tileSize + this.tileHalfSize;
					if(body.isBullet) {
						if(Math.abs(this.plane.distancePoint(this.tilePosition)) < 40) {
							if(glaze_physics_collision_Intersect.StaticAABBvsSweeptAABB(this.tilePosition,this.tileExtents,body.position,body.aabb.extents,body.delta,this.contact) == true) body.respondBulletCollision(this.contact);
						}
					} else if(glaze_physics_collision_Intersect.AABBvsStaticSolidAABB(body.position,body.aabb.extents,this.tilePosition,this.tileExtents,this.contact) == true) {
						var nextX = x + (this.contact.normal.x | 0);
						var nextY = y + (this.contact.normal.y | 0);
						var tmp5;
						var _this1 = this.data;
						tmp5 = _this1.data.b[nextY * _this1.internalWidth + nextX * _this1.bytesPerCell];
						var nextCell = tmp5;
						if(nextCell == 0) {
							body.respondStaticCollision(this.contact);
							if(this.debug != null) this.debug(x,y);
						} else {
						}
					}
				}
			}
		}
	}
	,castRay: function(ray) {
		var x = ray.origin.x * this.data.invCellSize | 0;
		var y = ray.origin.y * this.data.invCellSize | 0;
		var cX = x * this.tileSize;
		var cY = y * this.tileSize;
		var d = ray.direction;
		var stepX = 0;
		var tMaxX = 100000000;
		var tDeltaX = 0;
		if(d.x < 0) {
			stepX = -1;
			tMaxX = (cX - ray.origin.x) / d.x;
			tDeltaX = this.tileSize / -d.x;
		} else if(d.x > 0) {
			stepX = 1;
			tMaxX = (cX + this.tileSize - ray.origin.x) / d.x;
			tDeltaX = this.tileSize / d.x;
		}
		var stepY = 0;
		var tMaxY = 100000000;
		var tDeltaY = 0;
		if(d.y < 0) {
			stepY = -1;
			tMaxY = (cY - ray.origin.y) / d.y;
			tDeltaY = this.tileSize / -d.y;
		} else if(d.y > 0) {
			stepY = 1;
			tMaxY = (cY + this.tileSize - ray.origin.y) / d.y;
			tDeltaY = this.tileSize / d.y;
		}
		var distX = .0;
		var distY = .0;
		var transitionEdgeNormalX = 0;
		var transitionEdgeNormalY = 0;
		while(true) {
			if(tMaxX < tMaxY) {
				distX = tMaxX * d.x;
				distY = tMaxX * d.y;
				tMaxX += tDeltaX;
				x += stepX;
			} else {
				distX = tMaxY * d.x;
				distY = tMaxY * d.y;
				tMaxY += tDeltaY;
				y += stepY;
			}
			if(distX * distX + distY * distY > ray.range * ray.range) return false;
			var tmp;
			var _this = this.data;
			tmp = _this.data.b[y * _this.internalWidth + x * _this.bytesPerCell];
			var tile = tmp;
			if(tile > 0) {
				if(tMaxX < tMaxY) {
					transitionEdgeNormalX = stepX < 0?1:-1;
					transitionEdgeNormalY = 0;
				} else {
					transitionEdgeNormalX = 0;
					transitionEdgeNormalY = stepY < 0?1:-1;
				}
				ray.report(distX,distY,transitionEdgeNormalX,transitionEdgeNormalY);
				return true;
			}
		}
		return false;
	}
	,__class__: glaze_physics_collision_Map
};
var glaze_physics_collision_Ray = function() {
	this.contact = new glaze_physics_collision_Contact();
	this.direction = new glaze_geom_Vector2();
	this.delta = new glaze_geom_Vector2();
	this.range = 0;
	this.target = new glaze_geom_Vector2();
	this.origin = new glaze_geom_Vector2();
};
glaze_physics_collision_Ray.__name__ = ["glaze","physics","collision","Ray"];
glaze_physics_collision_Ray.prototype = {
	initalize: function(origin,target,range,callback) {
		this.reset();
		var _this = this.origin;
		_this.x = origin.x;
		_this.y = origin.y;
		var _this1 = this.target;
		_this1.x = target.x;
		_this1.y = target.y;
		var _this2 = this.delta;
		_this2.x = target.x;
		_this2.y = target.y;
		var _this3 = this.delta;
		_this3.x -= origin.x;
		_this3.y -= origin.y;
		var _this4 = this.direction;
		var v = this.delta;
		_this4.x = v.x;
		_this4.y = v.y;
		this.direction.normalize();
		if(range <= 0) {
			var tmp;
			var _this5 = this.delta;
			tmp = Math.sqrt(_this5.x * _this5.x + _this5.y * _this5.y);
			this.range = tmp;
		} else {
			this.range = range;
			var _this6 = this.delta;
			var v1 = this.direction;
			_this6.x = v1.x;
			_this6.y = v1.y;
			var _this7 = this.delta;
			_this7.x *= range;
			_this7.y *= range;
		}
		this.callback = callback;
	}
	,reset: function() {
		this.contact.distance = 9999999999;
		this.hit = false;
	}
	,report: function(distX,distY,normalX,normalY,proxy) {
		if(this.callback != null && proxy != null) {
			if(this.callback(proxy) < 0) {
				console.log("filtered");
				return;
			}
		}
		var distSqrd = distX * distX + distY * distY;
		if(distSqrd < this.contact.distance * this.contact.distance) {
			var _this = this.contact.position;
			_this.x = this.origin.x + distX;
			_this.y = this.origin.y + distY;
			var _this1 = this.contact.normal;
			_this1.x = normalX;
			_this1.y = normalY;
			this.contact.distance = Math.sqrt(distSqrd);
			this.hit = true;
		}
	}
	,__class__: glaze_physics_collision_Ray
};
var glaze_physics_collision_broadphase_IBroadphase = function() { };
glaze_physics_collision_broadphase_IBroadphase.__name__ = ["glaze","physics","collision","broadphase","IBroadphase"];
glaze_physics_collision_broadphase_IBroadphase.prototype = {
	__class__: glaze_physics_collision_broadphase_IBroadphase
};
var glaze_physics_collision_broadphase_BruteforceBroadphase = function(map,nf) {
	this.map = map;
	this.nf = nf;
	this.staticProxies = [];
	this.dynamicProxies = [];
};
glaze_physics_collision_broadphase_BruteforceBroadphase.__name__ = ["glaze","physics","collision","broadphase","BruteforceBroadphase"];
glaze_physics_collision_broadphase_BruteforceBroadphase.__interfaces__ = [glaze_physics_collision_broadphase_IBroadphase];
glaze_physics_collision_broadphase_BruteforceBroadphase.prototype = {
	addProxy: function(proxy) {
		var target = proxy.isStatic?this.staticProxies:this.dynamicProxies;
		target.push(proxy);
	}
	,removeProxy: function(proxy) {
		var target = proxy.isStatic?this.staticProxies:this.dynamicProxies;
		HxOverrides.remove(target,proxy);
	}
	,collide: function() {
		var count = this.dynamicProxies.length;
		var _g = 0;
		while(_g < count) {
			var i = _g++;
			var dynamicProxy = this.dynamicProxies[i];
			this.map.testCollision(dynamicProxy.body);
			var _g1 = 0;
			var _g2 = this.staticProxies;
			while(_g1 < _g2.length) {
				var staticProxy = _g2[_g1];
				++_g1;
				this.nf.Collide(dynamicProxy,staticProxy);
			}
			var _g11 = i + 1;
			while(_g11 < count) {
				var j = _g11++;
				var dynamicProxyB = this.dynamicProxies[j];
				this.nf.Collide(dynamicProxy,dynamicProxyB);
			}
		}
	}
	,QueryArea: function(aabb,result,checkDynamic,checkStatic) {
		if(checkStatic == null) checkStatic = true;
		if(checkDynamic == null) checkDynamic = true;
		if(checkDynamic) {
			var _g = 0;
			var _g1 = this.staticProxies;
			while(_g < _g1.length) {
				var proxy = _g1[_g];
				++_g;
				var tmp;
				if(!proxy.isSensor) {
					var aabb1 = proxy.aabb;
					if(Math.abs(aabb.position.x - aabb1.position.x) > aabb.extents.x + aabb1.extents.x) tmp = false; else if(Math.abs(aabb.position.y - aabb1.position.y) > aabb.extents.y + aabb1.extents.y) tmp = false; else tmp = true;
				} else tmp = false;
				if(tmp) result(proxy);
			}
		}
		if(checkStatic) {
			var _g2 = 0;
			var _g11 = this.dynamicProxies;
			while(_g2 < _g11.length) {
				var proxy1 = _g11[_g2];
				++_g2;
				var tmp1;
				if(!proxy1.isSensor) {
					var aabb2 = proxy1.aabb;
					if(Math.abs(aabb.position.x - aabb2.position.x) > aabb.extents.x + aabb2.extents.x) tmp1 = false; else if(Math.abs(aabb.position.y - aabb2.position.y) > aabb.extents.y + aabb2.extents.y) tmp1 = false; else tmp1 = true;
				} else tmp1 = false;
				if(tmp1) result(proxy1);
			}
		}
	}
	,CastRay: function(ray,result,checkDynamic,checkStatic) {
		if(checkStatic == null) checkStatic = true;
		if(checkDynamic == null) checkDynamic = true;
		this.map.castRay(ray);
		if(checkDynamic) {
			var _g = 0;
			var _g1 = this.dynamicProxies;
			while(_g < _g1.length) {
				var proxy = _g1[_g];
				++_g;
				if(!proxy.isSensor) this.nf.RayAABB(ray,proxy);
			}
		}
		if(checkStatic) {
			var _g2 = 0;
			var _g11 = this.staticProxies;
			while(_g2 < _g11.length) {
				var proxy1 = _g11[_g2];
				++_g2;
				if(!proxy1.isSensor) this.nf.RayAABB(ray,proxy1);
			}
		}
	}
	,__class__: glaze_physics_collision_broadphase_BruteforceBroadphase
};
var glaze_physics_components_PhysicsBody = function(body) {
	this.body = body;
};
glaze_physics_components_PhysicsBody.__name__ = ["glaze","physics","components","PhysicsBody"];
glaze_physics_components_PhysicsBody.__interfaces__ = [glaze_eco_core_IComponent];
glaze_physics_components_PhysicsBody.prototype = {
	__class__: glaze_physics_components_PhysicsBody
};
var glaze_physics_components_PhysicsCollision = function(proxy) {
	this.proxy = proxy;
};
glaze_physics_components_PhysicsCollision.__name__ = ["glaze","physics","components","PhysicsCollision"];
glaze_physics_components_PhysicsCollision.__interfaces__ = [glaze_eco_core_IComponent];
glaze_physics_components_PhysicsCollision.prototype = {
	__class__: glaze_physics_components_PhysicsCollision
};
var glaze_physics_systems_PhysicsCollisionSystem = function(broadphase) {
	glaze_eco_core_System.call(this,[glaze_physics_components_PhysicsCollision]);
	this.broadphase = broadphase;
};
glaze_physics_systems_PhysicsCollisionSystem.__name__ = ["glaze","physics","systems","PhysicsCollisionSystem"];
glaze_physics_systems_PhysicsCollisionSystem.__super__ = glaze_eco_core_System;
glaze_physics_systems_PhysicsCollisionSystem.prototype = $extend(glaze_eco_core_System.prototype,{
	entityAdded: function(entity) {
		var tmp;
		var value = entity.map.PhysicsCollision;
		if((value instanceof glaze_physics_components_PhysicsCollision)) tmp = value; else tmp = null;
		this.broadphase.addProxy(tmp.proxy);
	}
	,entityRemoved: function(entity) {
		var tmp;
		var value = entity.map.PhysicsCollision;
		if((value instanceof glaze_physics_components_PhysicsCollision)) tmp = value; else tmp = null;
		this.broadphase.removeProxy(tmp.proxy);
	}
	,update: function(timestamp,delta) {
		this.broadphase.collide();
	}
	,__class__: glaze_physics_systems_PhysicsCollisionSystem
});
var glaze_physics_systems_PhysicsUpdateSystem = function() {
	glaze_eco_core_System.call(this,[glaze_engine_components_Position,glaze_physics_components_PhysicsBody]);
	this.globalForce = new glaze_geom_Vector2(0,30);
	this.globalDamping = 0.99;
};
glaze_physics_systems_PhysicsUpdateSystem.__name__ = ["glaze","physics","systems","PhysicsUpdateSystem"];
glaze_physics_systems_PhysicsUpdateSystem.__super__ = glaze_eco_core_System;
glaze_physics_systems_PhysicsUpdateSystem.prototype = $extend(glaze_eco_core_System.prototype,{
	entityAdded: function(entity) {
	}
	,entityRemoved: function(entity) {
	}
	,update: function(timestamp,delta) {
		var _g = 0;
		var _g1 = this.view.entities;
		while(_g < _g1.length) {
			var entity = _g1[_g];
			++_g;
			var tmp;
			var value = entity.map.PhysicsBody;
			if((value instanceof glaze_physics_components_PhysicsBody)) tmp = value; else tmp = null;
			tmp.body.update(delta,this.globalForce,this.globalDamping);
		}
	}
	,__class__: glaze_physics_systems_PhysicsUpdateSystem
});
var glaze_render_display_DisplayObject = function() {
	this.position = new glaze_geom_Vector2();
	this.scale = new glaze_geom_Vector2(1,1);
	this.pivot = new glaze_geom_Vector2();
	this._rotationComponents = new glaze_geom_Vector2();
	this._rotation = 0;
	this._rotationComponents.x = Math.cos(this._rotation);
	this._rotationComponents.y = Math.sin(this._rotation);
	this.alpha = 1;
	this._visible = true;
	if(this.stage != null) this.stage.dirty = true;
	this.renderable = false;
	this.aabb = new glaze_geom_AABB2();
	this.parent = null;
	this.worldTransform = glaze_geom_Matrix3.Create();
	this.localTransform = glaze_geom_Matrix3.Create();
};
glaze_render_display_DisplayObject.__name__ = ["glaze","render","display","DisplayObject"];
glaze_render_display_DisplayObject.prototype = {
	get_rotation: function() {
		return this._rotation;
	}
	,set_rotation: function(v) {
		this._rotation = v;
		this._rotationComponents.x = Math.cos(this._rotation);
		this._rotationComponents.y = Math.sin(this._rotation);
		return this._rotation;
	}
	,get_visible: function() {
		return this._visible;
	}
	,set_visible: function(v) {
		this._visible = v;
		if(this.stage != null) this.stage.dirty = true;
		return this._visible;
	}
	,RoundFunction: function(v) {
		return Math.round(v * 10) / 10;
	}
	,updateTransform: function() {
		var positionx = Math.floor(this.position.x + 0.5);
		var positiony = Math.floor(this.position.y + 0.5);
		var sinR = this._rotationComponents.y;
		var cosR = this._rotationComponents.x;
		this.localTransform[0] = cosR * this.scale.x;
		this.localTransform[1] = -sinR * this.scale.y;
		this.localTransform[3] = sinR * this.scale.x;
		this.localTransform[4] = cosR * this.scale.y;
		var px = this.pivot.x;
		var py = this.pivot.y;
		var parentTransform = this.parent.worldTransform;
		var a00 = this.localTransform[0];
		var a01 = this.localTransform[1];
		var a02 = positionx - this.localTransform[0] * px - py * this.localTransform[1];
		var a10 = this.localTransform[3];
		var a11 = this.localTransform[4];
		var a12 = positiony - this.localTransform[4] * py - px * this.localTransform[3];
		var b00 = parentTransform[0];
		var b01 = parentTransform[1];
		var b02 = parentTransform[2];
		var b10 = parentTransform[3];
		var b11 = parentTransform[4];
		var b12 = parentTransform[5];
		this.localTransform[2] = a02;
		this.localTransform[5] = a12;
		this.worldTransform[0] = b00 * a00 + b01 * a10;
		this.worldTransform[1] = b00 * a01 + b01 * a11;
		this.worldTransform[2] = b00 * a02 + b01 * a12 + b02;
		this.worldTransform[3] = b10 * a00 + b11 * a10;
		this.worldTransform[4] = b10 * a01 + b11 * a11;
		this.worldTransform[5] = b10 * a02 + b11 * a12 + b12;
		this.worldAlpha = this.alpha * this.parent.worldAlpha;
	}
	,calcExtents: function() {
	}
	,applySlot: function(slot,p) {
		return slot(this,p);
	}
	,__class__: glaze_render_display_DisplayObject
};
var glaze_render_display_DisplayObjectContainer = function() {
	glaze_render_display_DisplayObject.call(this);
	this.subTreeAABB = new glaze_geom_AABB2();
	this.childCount = 0;
};
glaze_render_display_DisplayObjectContainer.__name__ = ["glaze","render","display","DisplayObjectContainer"];
glaze_render_display_DisplayObjectContainer.__super__ = glaze_render_display_DisplayObject;
glaze_render_display_DisplayObjectContainer.prototype = $extend(glaze_render_display_DisplayObject.prototype,{
	addChild: function(child) {
		if(child.parent != null) child.parent.removeChild(child);
		if(this.tail == null) {
			if(this.head == null) {
				this.head = child;
				this.tail = child;
				child.prev = null;
				child.next = null;
			} else {
				var node = this.head;
				child.prev = node.prev;
				child.next = node;
				if(node.prev == null) this.head = child; else node.prev.next = child;
				node.prev = child;
			}
		} else {
			var node1 = this.tail;
			child.prev = node1;
			child.next = node1.next;
			if(node1.next == null) this.tail = child; else node1.next.prev = child;
			node1.next = child;
		}
		this.childCount++;
		child.parent = this;
		child.applySlot(function(target,p) {
			target.stage = p;
			return true;
		},this.stage);
		if(this.stage != null) this.stage.dirty = true;
	}
	,addChildAt: function(child,index) {
		if(index >= this.childCount) {
			this.addChild(child);
			return;
		}
		if(index == 0) {
			if(this.head == null) {
				this.head = child;
				this.tail = child;
				child.prev = null;
				child.next = null;
			} else {
				var node = this.head;
				child.prev = node.prev;
				child.next = node;
				if(node.prev == null) this.head = child; else node.prev.next = child;
				node.prev = child;
			}
		} else {
			var node1 = this.findChildByIndex(index);
			child.prev = node1.prev;
			child.next = node1;
			if(node1.prev == null) this.head = child; else node1.prev.next = child;
			node1.prev = child;
		}
		this.childCount++;
		child.parent = this;
		child.applySlot(function(target,p) {
			target.stage = p;
			return true;
		},this.stage);
		if(this.stage != null) this.stage.dirty = true;
	}
	,childAdded: function(child) {
		this.childCount++;
		child.parent = this;
		child.applySlot(function(target,p) {
			target.stage = p;
			return true;
		},this.stage);
		if(this.stage != null) this.stage.dirty = true;
	}
	,findChildByIndex: function(index) {
		var child = this.head;
		var count = 0;
		while(child != null) {
			if(count++ == index) return child;
			child = child.next;
		}
		return this.tail;
	}
	,removeChild: function(child) {
		if(child.parent == this) {
			if(child.prev == null) this.head = child.next; else child.prev.next = child.next;
			if(child.next == null) this.tail = child.prev; else child.next.prev = child.prev;
			child.prev = child.next = null;
			this.childCount--;
			if(this.stage != null) this.stage.dirty = true;
			child.parent = null;
			child.applySlot(function(target,p) {
				target.stage = null;
				return true;
			},null);
		}
	}
	,removeChildAt: function(index) {
		var child = this.findChildByIndex(index);
		console.log(child);
		this.removeChild(child);
		this.debug();
		return child;
	}
	,childRemoved: function(child) {
		this.childCount--;
		if(this.stage != null) this.stage.dirty = true;
		child.parent = null;
		child.applySlot(function(target,p) {
			target.stage = null;
			return true;
		},null);
	}
	,updateTransform: function() {
		var _this = this.aabb;
		_this.t = _this.l = Infinity;
		_this.r = _this.b = -Infinity;
		glaze_render_display_DisplayObject.prototype.updateTransform.call(this);
		this.calcExtents();
		var _this1 = this.subTreeAABB;
		_this1.t = _this1.l = Infinity;
		_this1.r = _this1.b = -Infinity;
		var _this2 = this.subTreeAABB;
		var aabb = this.aabb;
		if(aabb.t < _this2.t) _this2.t = aabb.t;
		if(aabb.r > _this2.r) _this2.r = aabb.r;
		if(aabb.b > _this2.b) _this2.b = aabb.b;
		if(aabb.l < _this2.l) _this2.l = aabb.l;
		var child = this.head;
		while(child != null) {
			child.updateTransform();
			var _this3 = this.subTreeAABB;
			var aabb1 = child.aabb;
			if(aabb1.t < _this3.t) _this3.t = aabb1.t;
			if(aabb1.r > _this3.r) _this3.r = aabb1.r;
			if(aabb1.b > _this3.b) _this3.b = aabb1.b;
			if(aabb1.l < _this3.l) _this3.l = aabb1.l;
			child = child.next;
		}
	}
	,apply: function(slot,p) {
	}
	,applySlot: function(slot,p) {
		if(!glaze_render_display_DisplayObject.prototype.applySlot.call(this,slot,p)) return false;
		var child = this.head;
		while(child != null) {
			child.applySlot(slot,p);
			child = child.next;
		}
		return true;
	}
	,insertAfter: function(node,newNode) {
		newNode.prev = node;
		newNode.next = node.next;
		if(node.next == null) this.tail = newNode; else node.next.prev = newNode;
		node.next = newNode;
	}
	,insertBefore: function(node,newNode) {
		newNode.prev = node.prev;
		newNode.next = node;
		if(node.prev == null) this.head = newNode; else node.prev.next = newNode;
		node.prev = newNode;
	}
	,insertBeginning: function(newNode) {
		if(this.head == null) {
			this.head = newNode;
			this.tail = newNode;
			newNode.prev = null;
			newNode.next = null;
		} else {
			var node = this.head;
			newNode.prev = node.prev;
			newNode.next = node;
			if(node.prev == null) this.head = newNode; else node.prev.next = newNode;
			node.prev = newNode;
		}
	}
	,insertEnd: function(newNode) {
		if(this.tail == null) {
			if(this.head == null) {
				this.head = newNode;
				this.tail = newNode;
				newNode.prev = null;
				newNode.next = null;
			} else {
				var node = this.head;
				newNode.prev = node.prev;
				newNode.next = node;
				if(node.prev == null) this.head = newNode; else node.prev.next = newNode;
				node.prev = newNode;
			}
		} else {
			var node1 = this.tail;
			newNode.prev = node1;
			newNode.next = node1.next;
			if(node1.next == null) this.tail = newNode; else node1.next.prev = newNode;
			node1.next = newNode;
		}
	}
	,remove: function(node) {
		if(node.prev == null) this.head = node.next; else node.prev.next = node.next;
		if(node.next == null) this.tail = node.prev; else node.next.prev = node.prev;
		node.prev = node.next = null;
	}
	,debug: function() {
		var child = this.head;
		while(child != null) {
			console.log(child.id);
			child = child.next;
		}
	}
	,__class__: glaze_render_display_DisplayObjectContainer
});
var glaze_render_display_Camera = function() {
	glaze_render_display_DisplayObjectContainer.call(this);
	this.id = "Camera";
	this.realPosition = new glaze_geom_Vector2();
	this.viewportSize = new glaze_geom_Vector2();
	this.halfViewportSize = new glaze_geom_Vector2();
	this.viewPortAABB = new glaze_geom_AABB2();
	this.worldExtentsAABB = new glaze_geom_AABB2();
};
glaze_render_display_Camera.__name__ = ["glaze","render","display","Camera"];
glaze_render_display_Camera.__super__ = glaze_render_display_DisplayObjectContainer;
glaze_render_display_Camera.prototype = $extend(glaze_render_display_DisplayObjectContainer.prototype,{
	Focus: function(x,y) {
		this.realPosition.x = x;
		this.realPosition.y = y;
		var _this = this.cameraExtentsAABB;
		var point = this.realPosition;
		if(point.x < _this.l) point.x = _this.l;
		if(point.x > _this.r) point.x = _this.r;
		if(point.y < _this.t) point.y = _this.t;
		if(point.y > _this.b) point.y = _this.b;
		this.position.x = -this.realPosition.x + this.halfViewportSize.x;
		this.position.y = -this.realPosition.y + this.halfViewportSize.y;
	}
	,Resize: function(width,height) {
		this.viewportSize.x = width;
		this.viewportSize.y = height;
		this.halfViewportSize.x = width / 2;
		this.halfViewportSize.y = height / 2;
		this.viewPortAABB.l = this.viewPortAABB.t = 0;
		this.viewPortAABB.r = this.viewportSize.x;
		this.viewPortAABB.b = this.viewportSize.y;
		this.cameraExtentsAABB = this.worldExtentsAABB.clone();
		var _this = this.cameraExtentsAABB;
		_this.l += width / 2;
		_this.r -= width / 2;
		_this.t += height / 2;
		_this.b -= height / 2;
	}
	,__class__: glaze_render_display_Camera
});
var glaze_render_display_Sprite = function() {
	glaze_render_display_DisplayObjectContainer.call(this);
	this.renderable = true;
	this.anchor = new glaze_geom_Vector2();
	this.transformedVerts = new Float32Array(8);
};
glaze_render_display_Sprite.__name__ = ["glaze","render","display","Sprite"];
glaze_render_display_Sprite.__super__ = glaze_render_display_DisplayObjectContainer;
glaze_render_display_Sprite.prototype = $extend(glaze_render_display_DisplayObjectContainer.prototype,{
	calcExtents: function() {
		var width = this.texture.frame.width;
		var height = this.texture.frame.height;
		var aX = this.anchor.x;
		var aY = this.anchor.y;
		var w0 = width * (1 - aX);
		var w1 = width * -aX;
		var h0 = height * (1 - aY);
		var h1 = height * -aY;
		var a = this.worldTransform[0];
		var b = this.worldTransform[3];
		var c = this.worldTransform[1];
		var d = this.worldTransform[4];
		var tx = this.worldTransform[2];
		var ty = this.worldTransform[5];
		this.transformedVerts[0] = a * w1 + c * h1 + tx;
		this.transformedVerts[1] = d * h1 + b * w1 + ty;
		this.transformedVerts[2] = a * w0 + c * h1 + tx;
		this.transformedVerts[3] = d * h1 + b * w0 + ty;
		this.transformedVerts[4] = a * w0 + c * h0 + tx;
		this.transformedVerts[5] = d * h0 + b * w0 + ty;
		this.transformedVerts[6] = a * w1 + c * h0 + tx;
		this.transformedVerts[7] = d * h0 + b * w1 + ty;
		var _g = 0;
		while(_g < 4) {
			var i = _g++;
			var _this = this.aabb;
			var x = this.transformedVerts[i * 2];
			var y = this.transformedVerts[i * 2 + 1];
			if(x < _this.l) _this.l = x;
			if(x > _this.r) _this.r = x;
			if(y < _this.t) _this.t = y;
			if(y > _this.b) _this.b = y;
		}
	}
	,__class__: glaze_render_display_Sprite
});
var glaze_render_display_Stage = function() {
	glaze_render_display_DisplayObjectContainer.call(this);
	this.id = "Stage";
	this.worldAlpha = this.alpha;
	this.stage = this;
};
glaze_render_display_Stage.__name__ = ["glaze","render","display","Stage"];
glaze_render_display_Stage.__super__ = glaze_render_display_DisplayObjectContainer;
glaze_render_display_Stage.prototype = $extend(glaze_render_display_DisplayObjectContainer.prototype,{
	updateTransform: function() {
		var child = this.head;
		while(child != null) {
			child.updateTransform();
			child = child.next;
		}
	}
	,PreRender: function() {
		if(this.dirty == true) {
			this.Flatten();
			this.dirty = false;
		}
	}
	,Flatten: function() {
		this.renderHead = null;
		this.renderTail = null;
		this.renderCount = 0;
	}
	,Traverse: function(node) {
		if(node._visible == false) return;
		if(js_Boot.__instanceof(node,glaze_render_display_Sprite)) {
			if(this.renderHead == null) {
				this.renderHead = node;
				this.renderHead.prevSprite = this.renderHead.nextSprite = null;
			} else {
				var sprite = node;
				sprite.prevSprite = sprite.nextSprite = null;
				if(this.renderTail == null) {
					this.renderTail = sprite;
					this.renderHead.nextSprite = this.renderTail;
					this.renderTail.prevSprite = this.renderHead;
				} else {
					this.renderTail.nextSprite = sprite;
					sprite.prevSprite = this.renderTail;
					this.renderTail = sprite;
				}
			}
			this.renderCount++;
		}
		if(js_Boot.__instanceof(node,glaze_render_display_DisplayObjectContainer)) {
			var doc = node;
			var child = doc.head;
			while(child != null) {
				this.Traverse(child);
				child = child.next;
			}
		}
	}
	,__class__: glaze_render_display_Stage
});
var glaze_render_renderers_webgl_IRenderer = function() { };
glaze_render_renderers_webgl_IRenderer.__name__ = ["glaze","render","renderers","webgl","IRenderer"];
glaze_render_renderers_webgl_IRenderer.prototype = {
	__class__: glaze_render_renderers_webgl_IRenderer
};
var glaze_render_renderers_webgl_PointSpriteLightMapRenderer = function() {
};
glaze_render_renderers_webgl_PointSpriteLightMapRenderer.__name__ = ["glaze","render","renderers","webgl","PointSpriteLightMapRenderer"];
glaze_render_renderers_webgl_PointSpriteLightMapRenderer.__interfaces__ = [glaze_render_renderers_webgl_IRenderer];
glaze_render_renderers_webgl_PointSpriteLightMapRenderer.prototype = {
	Init: function(gl,camera) {
		this.gl = gl;
		this.camera = camera;
		this.projection = new glaze_geom_Vector2();
		this.pointSpriteShader = new glaze_render_renderers_webgl_ShaderWrapper(gl,glaze_render_renderers_webgl_WebGLShaders.CompileProgram(gl,glaze_render_renderers_webgl_PointSpriteLightMapRenderer.SPRITE_VERTEX_SHADER,glaze_render_renderers_webgl_PointSpriteLightMapRenderer.SPRITE_FRAGMENT_SHADER));
		this.dataBuffer = gl.createBuffer();
	}
	,ResizeBatch: function(size) {
		this.arrayBuffer = new ArrayBuffer(80 * size);
		this.data = new Float32Array(this.arrayBuffer);
		this.data8 = new Uint8ClampedArray(this.arrayBuffer);
		this.ResetBatch();
	}
	,Resize: function(width,height) {
		this.projection.x = width / 2;
		this.projection.y = height / 2;
	}
	,AddStage: function(stage) {
		this.stage = stage;
	}
	,ResetBatch: function() {
		this.indexRun = 0;
	}
	,AddSpriteToBatch: function(x,y,size,alpha,red,green,blue) {
		var index = this.indexRun * 4;
		this.data[index] = x + this.camera.position.x | 0;
		this.data[index + 1] = y + this.camera.position.y | 0;
		this.data[index + 2] = size;
		index *= 4;
		this.data8[index + 12] = red;
		this.data8[index + 13] = blue;
		this.data8[index + 14] = green;
		this.data8[index + 15] = alpha;
		this.indexRun++;
	}
	,Render: function(clip) {
		this.gl.enable(3042);
		this.gl.blendFunc(770,771);
		this.gl.useProgram(this.pointSpriteShader.program);
		this.gl.bindBuffer(34962,this.dataBuffer);
		this.gl.bufferData(34962,this.data,35048);
		this.gl.enableVertexAttribArray(this.pointSpriteShader.attribute.position);
		this.gl.enableVertexAttribArray(this.pointSpriteShader.attribute.size);
		this.gl.enableVertexAttribArray(this.pointSpriteShader.attribute.colour);
		this.gl.vertexAttribPointer(this.pointSpriteShader.attribute.position,2,5126,false,16,0);
		this.gl.vertexAttribPointer(this.pointSpriteShader.attribute.size,1,5126,false,16,8);
		this.gl.vertexAttribPointer(this.pointSpriteShader.attribute.colour,4,5121,true,16,12);
		this.gl.uniform2f(this.pointSpriteShader.uniform.projectionVector,this.projection.x,this.projection.y);
		this.gl.drawArrays(0,0,this.indexRun);
	}
	,__class__: glaze_render_renderers_webgl_PointSpriteLightMapRenderer
};
var glaze_render_renderers_webgl_ShaderWrapper = function(gl,program) {
	this.program = program;
	gl.useProgram(this.program);
	this.attribute = { };
	this.uniform = { };
	var cnt = gl.getProgramParameter(program,35721);
	var i = 0;
	while(i < cnt) {
		var attrib = gl.getActiveAttrib(program,i);
		this.attribute[attrib.name] = gl.getAttribLocation(program,attrib.name);
		i++;
	}
	cnt = gl.getProgramParameter(program,35718);
	i = 0;
	while(i < cnt) {
		var attrib1 = gl.getActiveUniform(program,i);
		this.uniform[attrib1.name] = gl.getUniformLocation(program,attrib1.name);
		i++;
	}
};
glaze_render_renderers_webgl_ShaderWrapper.__name__ = ["glaze","render","renderers","webgl","ShaderWrapper"];
glaze_render_renderers_webgl_ShaderWrapper.prototype = {
	__class__: glaze_render_renderers_webgl_ShaderWrapper
};
var glaze_render_renderers_webgl_SpriteRenderer = function() {
};
glaze_render_renderers_webgl_SpriteRenderer.__name__ = ["glaze","render","renderers","webgl","SpriteRenderer"];
glaze_render_renderers_webgl_SpriteRenderer.__interfaces__ = [glaze_render_renderers_webgl_IRenderer];
glaze_render_renderers_webgl_SpriteRenderer.prototype = {
	Init: function(gl,camera) {
		this.gl = gl;
		this.camera = camera;
		this.projection = new glaze_geom_Vector2();
		this.spriteShader = new glaze_render_renderers_webgl_ShaderWrapper(gl,glaze_render_renderers_webgl_WebGLShaders.CompileProgram(gl,glaze_render_renderers_webgl_SpriteRenderer.SPRITE_VERTEX_SHADER,glaze_render_renderers_webgl_SpriteRenderer.SPRITE_FRAGMENT_SHADER));
		this.spriteBatch = new glaze_render_renderers_webgl_WebGLBatch(gl);
		this.spriteBatch.ResizeBatch(1000);
	}
	,Resize: function(width,height) {
		this.projection.x = width / 2;
		this.projection.y = height / 2;
	}
	,AddStage: function(stage) {
		this.stage = stage;
	}
	,Render: function(clip) {
		this.gl.useProgram(this.spriteShader.program);
		this.gl.enableVertexAttribArray(this.spriteShader.attribute.aVertexPosition);
		this.gl.enableVertexAttribArray(this.spriteShader.attribute.aTextureCoord);
		this.gl.enableVertexAttribArray(this.spriteShader.attribute.aColor);
		this.gl.vertexAttribPointer(this.spriteShader.attribute.aVertexPosition,2,5126,false,20,0);
		this.gl.vertexAttribPointer(this.spriteShader.attribute.aTextureCoord,2,5126,false,20,8);
		this.gl.vertexAttribPointer(this.spriteShader.attribute.aColor,1,5126,false,20,16);
		this.gl.uniform2f(this.spriteShader.uniform.projectionVector,this.projection.x,this.projection.y);
		this.spriteBatch.Render(this.spriteShader,this.stage,this.camera.viewPortAABB);
	}
	,__class__: glaze_render_renderers_webgl_SpriteRenderer
};
var glaze_render_renderers_webgl_TileLayer = function() {
	this.scrollScale = new glaze_geom_Vector2(1,1);
	this.inverseTextureSize = new Float32Array(2);
};
glaze_render_renderers_webgl_TileLayer.__name__ = ["glaze","render","renderers","webgl","TileLayer"];
glaze_render_renderers_webgl_TileLayer.prototype = {
	setTextureFromMap: function(gl,data) {
		if(this.tileTexture == null) this.tileTexture = gl.createTexture();
		gl.bindTexture(3553,this.tileTexture);
		gl.texImage2D(3553,0,6408,data.w,data.h,0,6408,5121,data.data8);
		gl.texParameteri(3553,10240,9728);
		gl.texParameteri(3553,10241,9728);
		gl.texParameteri(3553,10242,33071);
		gl.texParameteri(3553,10243,33071);
		this.inverseTextureSize[0] = 1 / data.w;
		this.inverseTextureSize[1] = 1 / data.h;
	}
	,setTexture: function(gl,image,repeat) {
		if(this.tileTexture == null) this.tileTexture = gl.createTexture();
		gl.bindTexture(3553,this.tileTexture);
		gl.texImage2D(3553,0,6408,6408,5121,image);
		gl.texParameteri(3553,10240,9728);
		gl.texParameteri(3553,10241,9728);
		if(repeat) {
			gl.texParameteri(3553,10242,10497);
			gl.texParameteri(3553,10243,10497);
		} else {
			gl.texParameteri(3553,10242,33071);
			gl.texParameteri(3553,10243,33071);
		}
		this.inverseTextureSize[0] = 1 / image.width;
		this.inverseTextureSize[1] = 1 / image.height;
	}
	,__class__: glaze_render_renderers_webgl_TileLayer
};
var glaze_render_renderers_webgl_TileMap = function() {
};
glaze_render_renderers_webgl_TileMap.__name__ = ["glaze","render","renderers","webgl","TileMap"];
glaze_render_renderers_webgl_TileMap.__interfaces__ = [glaze_render_renderers_webgl_IRenderer];
glaze_render_renderers_webgl_TileMap.prototype = {
	Init: function(gl,camera) {
		this.gl = gl;
		this.camera = camera;
		this.tileScale = 1.0;
		this.tileSize = 16;
		this.filtered = false;
		this.spriteSheet = gl.createTexture();
		this.layers = [];
		this.viewportSize = new glaze_geom_Vector2();
		this.scaledViewportSize = new Float32Array(2);
		this.inverseTileTextureSize = new Float32Array(2);
		this.inverseSpriteTextureSize = new Float32Array(2);
		this.quadVertBuffer = gl.createBuffer();
		gl.bindBuffer(34962,this.quadVertBuffer);
		var quadVerts = new Float32Array([-1,-1,0,1,1,-1,1,1,1,1,1,0,-1,-1,0,1,1,1,1,0,-1,1,0,0]);
		gl.bufferData(34962,quadVerts,35044);
		this.tilemapShader = new glaze_render_renderers_webgl_ShaderWrapper(gl,glaze_render_renderers_webgl_WebGLShaders.CompileProgram(gl,glaze_render_renderers_webgl_TileMap.TILEMAP_VERTEX_SHADER,glaze_render_renderers_webgl_TileMap.TILEMAP_FRAGMENT_SHADER));
	}
	,Resize: function(width,height) {
		this.viewportSize.x = width;
		this.viewportSize.y = height;
		this.scaledViewportSize[0] = width / this.tileScale;
		this.scaledViewportSize[1] = height / this.tileScale;
	}
	,TileScale: function(scale) {
		this.tileScale = scale;
		this.scaledViewportSize[0] = this.viewportSize.x / scale;
		this.scaledViewportSize[1] = this.viewportSize.y / scale;
	}
	,Filtered: function(filtered) {
		this.filtered = filtered;
		this.gl.bindTexture(3553,this.spriteSheet);
		if(filtered) {
			this.gl.texParameteri(3553,10240,9728);
			this.gl.texParameteri(3553,10241,9728);
		} else {
			this.gl.texParameteri(3553,10240,9729);
			this.gl.texParameteri(3553,10241,9729);
		}
	}
	,SetSpriteSheet: function(image) {
		this.gl.bindTexture(3553,this.spriteSheet);
		this.gl.texImage2D(3553,0,6408,6408,5121,image);
		if(!this.filtered) {
			this.gl.texParameteri(3553,10240,9728);
			this.gl.texParameteri(3553,10241,9728);
		} else {
			this.gl.texParameteri(3553,10240,9729);
			this.gl.texParameteri(3553,10241,9729);
		}
		this.inverseSpriteTextureSize[0] = 1 / image.width;
		this.inverseSpriteTextureSize[1] = 1 / image.height;
	}
	,SetTileLayer: function(image,layerId,scrollScaleX,scrollScaleY) {
		var layer = new glaze_render_renderers_webgl_TileLayer();
		layer.setTexture(this.gl,image,false);
		layer.scrollScale.x = scrollScaleX;
		layer.scrollScale.y = scrollScaleY;
		this.layers.push(layer);
	}
	,SetTileLayerFromData: function(data,layerId,scrollScaleX,scrollScaleY) {
		var layer = new glaze_render_renderers_webgl_TileLayer();
		layer.setTextureFromMap(this.gl,data);
		layer.scrollScale.x = scrollScaleX;
		layer.scrollScale.y = scrollScaleY;
		this.layers.push(layer);
	}
	,RoundFunction: function(v) {
		return v;
	}
	,Render: function(clip) {
		var x = -this.camera.position.x / (this.tileScale * 2);
		var y = -this.camera.position.y / (this.tileScale * 2);
		this.gl.enable(3042);
		this.gl.blendFunc(770,771);
		this.gl.useProgram(this.tilemapShader.program);
		this.gl.bindBuffer(34962,this.quadVertBuffer);
		this.gl.enableVertexAttribArray(this.tilemapShader.attribute.position);
		this.gl.enableVertexAttribArray(this.tilemapShader.attribute.texture);
		this.gl.vertexAttribPointer(this.tilemapShader.attribute.position,2,5126,false,16,0);
		this.gl.vertexAttribPointer(this.tilemapShader.attribute.texture,2,5126,false,16,8);
		this.gl.uniform2fv(this.tilemapShader.uniform.viewportSize,this.scaledViewportSize);
		this.gl.uniform2fv(this.tilemapShader.uniform.inverseSpriteTextureSize,this.inverseSpriteTextureSize);
		this.gl.uniform1f(this.tilemapShader.uniform.tileSize,this.tileSize);
		this.gl.uniform1f(this.tilemapShader.uniform.inverseTileSize,1 / this.tileSize);
		this.gl.activeTexture(33984);
		this.gl.uniform1i(this.tilemapShader.uniform.sprites,0);
		this.gl.bindTexture(3553,this.spriteSheet);
		this.gl.activeTexture(33985);
		this.gl.uniform1i(this.tilemapShader.uniform.tiles,1);
		var i = this.layers.length;
		while(i > 0) {
			i--;
			var layer = this.layers[i];
			var pX = this.RoundFunction(x * this.tileScale * layer.scrollScale.x);
			var pY = this.RoundFunction(y * this.tileScale * layer.scrollScale.y);
			this.gl.uniform2f(this.tilemapShader.uniform.viewOffset,pX,pY);
			this.gl.uniform2fv(this.tilemapShader.uniform.inverseTileTextureSize,layer.inverseTextureSize);
			this.gl.bindTexture(3553,layer.tileTexture);
			this.gl.drawArrays(4,0,6);
		}
	}
	,__class__: glaze_render_renderers_webgl_TileMap
};
var glaze_render_renderers_webgl_WebGLBatch = function(gl) {
	this.gl = gl;
	this.size = 1;
	this.indexBuffer = gl.createBuffer();
	this.dataBuffer = gl.createBuffer();
	this.blendMode = 0;
	this.dynamicSize = 1;
};
glaze_render_renderers_webgl_WebGLBatch.__name__ = ["glaze","render","renderers","webgl","WebGLBatch"];
glaze_render_renderers_webgl_WebGLBatch.prototype = {
	Clean: function() {
	}
	,ResizeBatch: function(size) {
		this.size = size;
		this.dynamicSize = size;
		this.data = new Float32Array(this.dynamicSize * 20);
		this.gl.bindBuffer(34962,this.dataBuffer);
		this.gl.bufferData(34962,this.data,35048);
		this.indices = new Uint16Array(this.dynamicSize * 6);
		var _g1 = 0;
		var _g = this.dynamicSize;
		while(_g1 < _g) {
			var i = _g1++;
			var index2 = i * 6;
			var index3 = i * 4;
			this.indices[index2] = index3;
			this.indices[index2 + 1] = index3 + 1;
			this.indices[index2 + 2] = index3 + 2;
			this.indices[index2 + 3] = index3;
			this.indices[index2 + 4] = index3 + 2;
			this.indices[index2 + 5] = index3 + 3;
		}
		this.gl.bindBuffer(34963,this.indexBuffer);
		this.gl.bufferData(34963,this.indices,35044);
	}
	,Flush: function(shader,texture,size) {
		this.gl.bindBuffer(34962,this.dataBuffer);
		this.gl.bufferData(34962,this.data,35044);
		this.gl.vertexAttribPointer(shader.attribute.aVertexPosition,2,5126,false,20,0);
		this.gl.vertexAttribPointer(shader.attribute.aTextureCoord,2,5126,false,20,8);
		this.gl.vertexAttribPointer(shader.attribute.aColor,1,5126,false,20,16);
		this.gl.activeTexture(33984);
		this.gl.bindTexture(3553,texture);
		this.gl.drawElements(4,size * 6,5123,0);
	}
	,AddSpriteToBatch: function(sprite,indexRun) {
		var index = indexRun * 20;
		var uvs = sprite.texture.uvs;
		this.data[index] = sprite.transformedVerts[0];
		this.data[index + 1] = sprite.transformedVerts[1];
		this.data[index + 2] = uvs[0];
		this.data[index + 3] = uvs[1];
		this.data[index + 4] = sprite.worldAlpha;
		this.data[index + 5] = sprite.transformedVerts[2];
		this.data[index + 6] = sprite.transformedVerts[3];
		this.data[index + 7] = uvs[2];
		this.data[index + 8] = uvs[3];
		this.data[index + 9] = sprite.worldAlpha;
		this.data[index + 10] = sprite.transformedVerts[4];
		this.data[index + 11] = sprite.transformedVerts[5];
		this.data[index + 12] = uvs[4];
		this.data[index + 13] = uvs[5];
		this.data[index + 14] = sprite.worldAlpha;
		this.data[index + 15] = sprite.transformedVerts[6];
		this.data[index + 16] = sprite.transformedVerts[7];
		this.data[index + 17] = uvs[6];
		this.data[index + 18] = uvs[7];
		this.data[index + 19] = sprite.worldAlpha;
	}
	,Render: function(shader,stage,clip) {
		this.gl.useProgram(shader.program);
		var node;
		var stack;
		var top;
		node = stage;
		stack = [];
		stack[0] = node;
		top = 1;
		var indexRun = 0;
		var currentTexture = null;
		while(top > 0) {
			var thisNode = stack[--top];
			if(thisNode.next != null) stack[top++] = thisNode.next;
			if(thisNode.head != null) stack[top++] = thisNode.head;
			if(thisNode._visible && thisNode.renderable) {
				var sprite = thisNode;
				if(sprite.texture.baseTexture.texture != currentTexture || indexRun == this.size) {
					this.Flush(shader,currentTexture,indexRun);
					indexRun = 0;
					currentTexture = sprite.texture.baseTexture.texture;
				}
				var tmp;
				if(!(clip == null)) {
					var _this = sprite.aabb;
					if(_this.l > clip.r) tmp = false; else if(_this.r < clip.l) tmp = false; else if(_this.t > clip.b) tmp = false; else if(_this.b < clip.t) tmp = false; else tmp = true;
				} else tmp = true;
				if(tmp) {
					var index = indexRun * 20;
					var uvs = sprite.texture.uvs;
					this.data[index] = sprite.transformedVerts[0];
					this.data[index + 1] = sprite.transformedVerts[1];
					this.data[index + 2] = uvs[0];
					this.data[index + 3] = uvs[1];
					this.data[index + 4] = sprite.worldAlpha;
					this.data[index + 5] = sprite.transformedVerts[2];
					this.data[index + 6] = sprite.transformedVerts[3];
					this.data[index + 7] = uvs[2];
					this.data[index + 8] = uvs[3];
					this.data[index + 9] = sprite.worldAlpha;
					this.data[index + 10] = sprite.transformedVerts[4];
					this.data[index + 11] = sprite.transformedVerts[5];
					this.data[index + 12] = uvs[4];
					this.data[index + 13] = uvs[5];
					this.data[index + 14] = sprite.worldAlpha;
					this.data[index + 15] = sprite.transformedVerts[6];
					this.data[index + 16] = sprite.transformedVerts[7];
					this.data[index + 17] = uvs[6];
					this.data[index + 18] = uvs[7];
					this.data[index + 19] = sprite.worldAlpha;
					indexRun++;
				}
			}
		}
		if(indexRun > 0) this.Flush(shader,currentTexture,indexRun);
	}
	,Render2: function(shader,stage,clip) {
		var _g = this;
		this.gl.useProgram(shader.program);
		var indexRun = 0;
		var currentTexture = null;
		var renderDisplayObject = function(target,p) {
			if(!target._visible) return false;
			if(!target.renderable) return true;
			var sprite = target;
			if(sprite.texture.baseTexture.texture != currentTexture || indexRun == _g.size) {
				_g.Flush(shader,currentTexture,indexRun);
				indexRun = 0;
				currentTexture = sprite.texture.baseTexture.texture;
			}
			var tmp;
			if(!(clip == null)) {
				var _this = sprite.aabb;
				if(_this.l > clip.r) tmp = false; else if(_this.r < clip.l) tmp = false; else if(_this.t > clip.b) tmp = false; else if(_this.b < clip.t) tmp = false; else tmp = true;
			} else tmp = true;
			if(tmp) {
				var index = indexRun * 20;
				var uvs = sprite.texture.uvs;
				_g.data[index] = sprite.transformedVerts[0];
				_g.data[index + 1] = sprite.transformedVerts[1];
				_g.data[index + 2] = uvs[0];
				_g.data[index + 3] = uvs[1];
				_g.data[index + 4] = sprite.worldAlpha;
				_g.data[index + 5] = sprite.transformedVerts[2];
				_g.data[index + 6] = sprite.transformedVerts[3];
				_g.data[index + 7] = uvs[2];
				_g.data[index + 8] = uvs[3];
				_g.data[index + 9] = sprite.worldAlpha;
				_g.data[index + 10] = sprite.transformedVerts[4];
				_g.data[index + 11] = sprite.transformedVerts[5];
				_g.data[index + 12] = uvs[4];
				_g.data[index + 13] = uvs[5];
				_g.data[index + 14] = sprite.worldAlpha;
				_g.data[index + 15] = sprite.transformedVerts[6];
				_g.data[index + 16] = sprite.transformedVerts[7];
				_g.data[index + 17] = uvs[6];
				_g.data[index + 18] = uvs[7];
				_g.data[index + 19] = sprite.worldAlpha;
				indexRun++;
			}
			return true;
		};
		stage.applySlot(renderDisplayObject);
		if(indexRun > 0) this.Flush(shader,currentTexture,indexRun);
	}
	,Render1: function(shader,spriteHead,clip) {
		if(spriteHead == null) return;
		this.gl.useProgram(shader.program);
		var indexRun = 0;
		var sprite = spriteHead;
		var currentTexture = spriteHead.texture.baseTexture.texture;
		while(sprite != null) {
			if(sprite.texture.baseTexture.texture != currentTexture || indexRun == this.size) {
				this.Flush(shader,currentTexture,indexRun);
				indexRun = 0;
				currentTexture = sprite.texture.baseTexture.texture;
			}
			var tmp;
			if(!(clip == null)) {
				var _this = sprite.aabb;
				if(_this.l > clip.r) tmp = false; else if(_this.r < clip.l) tmp = false; else if(_this.t > clip.b) tmp = false; else if(_this.b < clip.t) tmp = false; else tmp = true;
			} else tmp = true;
			if(tmp) {
				var index = indexRun * 20;
				var uvs = sprite.texture.uvs;
				this.data[index] = sprite.transformedVerts[0];
				this.data[index + 1] = sprite.transformedVerts[1];
				this.data[index + 2] = uvs[0];
				this.data[index + 3] = uvs[1];
				this.data[index + 4] = sprite.worldAlpha;
				this.data[index + 5] = sprite.transformedVerts[2];
				this.data[index + 6] = sprite.transformedVerts[3];
				this.data[index + 7] = uvs[2];
				this.data[index + 8] = uvs[3];
				this.data[index + 9] = sprite.worldAlpha;
				this.data[index + 10] = sprite.transformedVerts[4];
				this.data[index + 11] = sprite.transformedVerts[5];
				this.data[index + 12] = uvs[4];
				this.data[index + 13] = uvs[5];
				this.data[index + 14] = sprite.worldAlpha;
				this.data[index + 15] = sprite.transformedVerts[6];
				this.data[index + 16] = sprite.transformedVerts[7];
				this.data[index + 17] = uvs[6];
				this.data[index + 18] = uvs[7];
				this.data[index + 19] = sprite.worldAlpha;
				indexRun++;
			}
			sprite = sprite.nextSprite;
		}
		if(indexRun > 0) this.Flush(shader,currentTexture,indexRun);
	}
	,__class__: glaze_render_renderers_webgl_WebGLBatch
};
var glaze_render_renderers_webgl_WebGLRenderer = function(stage,camera,view,width,height,transparent,antialias) {
	if(antialias == null) antialias = false;
	if(transparent == null) transparent = false;
	if(height == null) height = 600;
	if(width == null) width = 800;
	this.stage = stage;
	this.camera = camera;
	this.view = view;
	this.contextLost = false;
	this.contextAttributes = { };
	this.contextAttributes.alpha = transparent;
	this.contextAttributes.antialias = antialias;
	this.contextAttributes.premultipliedAlpha = false;
	this.contextAttributes.stencil = false;
	this.renderers = [];
	this.InitalizeWebGlContext();
	this.Resize(width,height);
};
glaze_render_renderers_webgl_WebGLRenderer.__name__ = ["glaze","render","renderers","webgl","WebGLRenderer"];
glaze_render_renderers_webgl_WebGLRenderer.prototype = {
	InitalizeWebGlContext: function() {
		this.view.addEventListener("webglcontextlost",$bind(this,this.onContextLost),false);
		this.view.addEventListener("webglcontextrestored",$bind(this,this.onContextRestored),false);
		this.gl = js_html__$CanvasElement_CanvasUtil.getContextWebGL(this.view,this.contextAttributes);
		this.gl.disable(2929);
		this.gl.disable(2884);
		this.gl.enable(3042);
		this.gl.colorMask(true,true,true,this.contextAttributes.alpha);
		this.gl.clearColor(0,0,0,1);
	}
	,Resize: function(width,height) {
		this.width = width;
		this.height = height;
		this.view.width = width;
		this.view.height = height;
		this.gl.viewport(0,0,width,height);
	}
	,AddRenderer: function(renderer) {
		renderer.Init(this.gl,this.camera);
		renderer.Resize(this.width,this.height);
		this.renderers.push(renderer);
	}
	,Render: function(clip) {
		if(this.contextLost) return;
		this.stage.updateTransform();
		this.stage.PreRender();
		var _g = 0;
		var _g1 = this.renderers;
		while(_g < _g1.length) {
			var renderer = _g1[_g];
			++_g;
			renderer.Render(clip);
		}
	}
	,onContextLost: function(event) {
		this.contextLost = true;
		console.log("webGL Context Lost");
	}
	,onContextRestored: function(event) {
		this.contextLost = false;
		console.log("webGL Context Restored");
	}
	,__class__: glaze_render_renderers_webgl_WebGLRenderer
};
var glaze_render_renderers_webgl_WebGLShaders = function() { };
glaze_render_renderers_webgl_WebGLShaders.__name__ = ["glaze","render","renderers","webgl","WebGLShaders"];
glaze_render_renderers_webgl_WebGLShaders.CompileVertexShader = function(gl,shaderSrc) {
	return glaze_render_renderers_webgl_WebGLShaders.CompileShader(gl,shaderSrc,35633);
};
glaze_render_renderers_webgl_WebGLShaders.CompileFragmentShader = function(gl,shaderSrc) {
	return glaze_render_renderers_webgl_WebGLShaders.CompileShader(gl,shaderSrc,35632);
};
glaze_render_renderers_webgl_WebGLShaders.CompileShader = function(gl,shaderSrc,shaderType) {
	var src = shaderSrc.join("\n");
	var shader = gl.createShader(shaderType);
	gl.shaderSource(shader,src);
	gl.compileShader(shader);
	if(!gl.getShaderParameter(shader,35713)) {
		js_Browser.alert(gl.getShaderInfoLog(shader));
		return null;
	}
	return shader;
};
glaze_render_renderers_webgl_WebGLShaders.CompileProgram = function(gl,vertexSrc,fragmentSrc) {
	var vertexShader = glaze_render_renderers_webgl_WebGLShaders.CompileVertexShader(gl,vertexSrc);
	var fragmentShader = glaze_render_renderers_webgl_WebGLShaders.CompileFragmentShader(gl,fragmentSrc);
	var shaderProgram = gl.createProgram();
	gl.attachShader(shaderProgram,vertexShader);
	gl.attachShader(shaderProgram,fragmentShader);
	gl.linkProgram(shaderProgram);
	if(!gl.getProgramParameter(shaderProgram,35714)) {
		js_Browser.alert("Could not initialize program");
		console.log(vertexSrc);
		console.log(fragmentSrc);
		console.log(gl.getProgramInfoLog(shaderProgram));
	}
	return shaderProgram;
};
var glaze_render_texture_BaseTexture = function(source) {
	this.source = source;
	this.powerOfTwo = false;
	this.resolution = 1;
	this.width = source.width;
	this.height = source.width;
};
glaze_render_texture_BaseTexture.__name__ = ["glaze","render","texture","BaseTexture"];
glaze_render_texture_BaseTexture.prototype = {
	RegisterTexture: function(gl) {
		if(this.texture == null) this.texture = gl.createTexture();
		gl.bindTexture(3553,this.texture);
		gl.pixelStorei(37441,1);
		gl.texImage2D(3553,0,6408,6408,5121,this.source);
		gl.texParameteri(3553,10240,9729);
		gl.texParameteri(3553,10241,9729);
		if(this.powerOfTwo) {
			gl.texParameteri(3553,10242,10497);
			gl.texParameteri(3553,10243,10497);
		} else {
			gl.texParameteri(3553,10242,33071);
			gl.texParameteri(3553,10243,33071);
		}
		gl.bindTexture(3553,null);
	}
	,UnregisterTexture: function(gl) {
	}
	,__class__: glaze_render_texture_BaseTexture
};
var glaze_render_texture_Texture = function(baseTexture,frame,pivot) {
	this.noFrame = false;
	this.baseTexture = baseTexture;
	if(frame == null) {
		this.noFrame = true;
		this.frame = new glaze_geom_Rectangle(0,0,1,1);
	} else this.frame = frame;
	this.trim = new glaze_geom_Vector2();
	this.pivot = pivot == null?new glaze_geom_Vector2():pivot;
	this.uvs = new Float32Array(8);
	this.updateUVS();
};
glaze_render_texture_Texture.__name__ = ["glaze","render","texture","Texture"];
glaze_render_texture_Texture.prototype = {
	updateUVS: function() {
		var tw = this.baseTexture.width;
		var th = this.baseTexture.height;
		this.uvs[0] = this.frame.x / tw;
		this.uvs[1] = this.frame.y / th;
		this.uvs[2] = (this.frame.x + this.frame.width) / tw;
		this.uvs[3] = this.frame.y / th;
		this.uvs[4] = (this.frame.x + this.frame.width) / tw;
		this.uvs[5] = (this.frame.y + this.frame.height) / th;
		this.uvs[6] = this.frame.x / tw;
		this.uvs[7] = (this.frame.y + this.frame.height) / th;
	}
	,__class__: glaze_render_texture_Texture
};
var glaze_render_texture_TextureManager = function(gl) {
	this.gl = gl;
	this.baseTextures = new haxe_ds_StringMap();
	this.textures = new haxe_ds_StringMap();
};
glaze_render_texture_TextureManager.__name__ = ["glaze","render","texture","TextureManager"];
glaze_render_texture_TextureManager.prototype = {
	AddTexture: function(id,image) {
		var baseTexture = new glaze_render_texture_BaseTexture(image);
		baseTexture.RegisterTexture(this.gl);
		var _this = this.baseTextures;
		if(__map_reserved[id] != null) _this.setReserved(id,baseTexture); else _this.h[id] = baseTexture;
		return baseTexture;
	}
	,ParseTexturePackerJSON: function(textureConfig,id) {
		if(!(typeof(textureConfig) == "string")) return;
		var tmp;
		var _this = this.baseTextures;
		if(__map_reserved[id] != null) tmp = _this.getReserved(id); else tmp = _this.h[id];
		var baseTexture = tmp;
		var textureData = JSON.parse(textureConfig);
		var fields = Reflect.fields(textureData.frames);
		var _g = 0;
		while(_g < fields.length) {
			var prop = fields[_g];
			++_g;
			var frame = Reflect.field(textureData.frames,prop);
			var _this1 = this.textures;
			var value = new glaze_render_texture_Texture(baseTexture,new glaze_geom_Rectangle(Std.parseInt(frame.frame.x),Std.parseInt(frame.frame.y),Std.parseInt(frame.frame.w),Std.parseInt(frame.frame.h)),new glaze_geom_Vector2(parseFloat(frame.pivot.x),parseFloat(frame.pivot.y)));
			if(__map_reserved[prop] != null) _this1.setReserved(prop,value); else _this1.h[prop] = value;
		}
	}
	,ParseTexturesFromTiles: function(tileSize,id) {
	}
	,__class__: glaze_render_texture_TextureManager
};
var glaze_signals_ListenerNode = function() {
};
glaze_signals_ListenerNode.__name__ = ["glaze","signals","ListenerNode"];
glaze_signals_ListenerNode.prototype = {
	__class__: glaze_signals_ListenerNode
};
var glaze_signals_ListenerNodePool = function() {
};
glaze_signals_ListenerNodePool.__name__ = ["glaze","signals","ListenerNodePool"];
glaze_signals_ListenerNodePool.prototype = {
	get: function() {
		if(this.tail != null) {
			var node = this.tail;
			this.tail = this.tail.previous;
			node.previous = null;
			return node;
		} else return new glaze_signals_ListenerNode();
	}
	,dispose: function(node) {
		node.listener = null;
		node.once = false;
		node.next = null;
		node.previous = this.tail;
		this.tail = node;
	}
	,cache: function(node) {
		node.listener = null;
		node.previous = this.cacheTail;
		this.cacheTail = node;
	}
	,releaseCache: function() {
		while(this.cacheTail != null) {
			var node = this.cacheTail;
			this.cacheTail = node.previous;
			node.next = null;
			node.previous = this.tail;
			this.tail = node;
		}
	}
	,__class__: glaze_signals_ListenerNodePool
};
var glaze_signals_SignalBase = function() {
	this.listenerNodePool = new glaze_signals_ListenerNodePool();
	this.numListeners = 0;
};
glaze_signals_SignalBase.__name__ = ["glaze","signals","SignalBase"];
glaze_signals_SignalBase.prototype = {
	startDispatch: function() {
		this.dispatching = true;
	}
	,endDispatch: function() {
		this.dispatching = false;
		if(this.toAddHead != null) {
			if(this.head == null) {
				this.head = this.toAddHead;
				this.tail = this.toAddTail;
			} else {
				this.tail.next = this.toAddHead;
				this.toAddHead.previous = this.tail;
				this.tail = this.toAddTail;
			}
			this.toAddHead = null;
			this.toAddTail = null;
		}
		this.listenerNodePool.releaseCache();
	}
	,getNode: function(listener) {
		var node = this.head;
		while(node != null) {
			if(Reflect.compareMethods(node.listener,listener)) break;
			node = node.next;
		}
		if(node == null) {
			node = this.toAddHead;
			while(node != null) {
				if(Reflect.compareMethods(node.listener,listener)) break;
				node = node.next;
			}
		}
		return node;
	}
	,nodeExists: function(listener) {
		var tmp;
		var node = this.head;
		while(node != null) {
			if(Reflect.compareMethods(node.listener,listener)) break;
			node = node.next;
		}
		if(node == null) {
			node = this.toAddHead;
			while(node != null) {
				if(Reflect.compareMethods(node.listener,listener)) break;
				node = node.next;
			}
		}
		tmp = node;
		return tmp != null;
	}
	,add: function(listener) {
		var tmp;
		var node1 = this.head;
		while(node1 != null) {
			if(Reflect.compareMethods(node1.listener,listener)) break;
			node1 = node1.next;
		}
		if(node1 == null) {
			node1 = this.toAddHead;
			while(node1 != null) {
				if(Reflect.compareMethods(node1.listener,listener)) break;
				node1 = node1.next;
			}
		}
		tmp = node1;
		if(tmp != null) return;
		var node = this.listenerNodePool.get();
		node.listener = listener;
		this.addNode(node);
	}
	,addOnce: function(listener) {
		var tmp;
		var node1 = this.head;
		while(node1 != null) {
			if(Reflect.compareMethods(node1.listener,listener)) break;
			node1 = node1.next;
		}
		if(node1 == null) {
			node1 = this.toAddHead;
			while(node1 != null) {
				if(Reflect.compareMethods(node1.listener,listener)) break;
				node1 = node1.next;
			}
		}
		tmp = node1;
		if(tmp != null) return;
		var node = this.listenerNodePool.get();
		node.listener = listener;
		node.once = true;
		this.addNode(node);
	}
	,addNode: function(node) {
		if(this.dispatching) {
			if(this.toAddHead == null) this.toAddHead = this.toAddTail = node; else {
				this.toAddTail.next = node;
				node.previous = this.toAddTail;
				this.toAddTail = node;
			}
		} else if(this.head == null) this.head = this.tail = node; else {
			this.tail.next = node;
			node.previous = this.tail;
			this.tail = node;
		}
		this.numListeners++;
	}
	,remove: function(listener) {
		var tmp;
		var node1 = this.head;
		while(node1 != null) {
			if(Reflect.compareMethods(node1.listener,listener)) break;
			node1 = node1.next;
		}
		if(node1 == null) {
			node1 = this.toAddHead;
			while(node1 != null) {
				if(Reflect.compareMethods(node1.listener,listener)) break;
				node1 = node1.next;
			}
		}
		tmp = node1;
		var node = tmp;
		if(node != null) {
			if(this.head == node) this.head = this.head.next;
			if(this.tail == node) this.tail = this.tail.previous;
			if(this.toAddHead == node) this.toAddHead = this.toAddHead.next;
			if(this.toAddTail == node) this.toAddTail = this.toAddTail.previous;
			if(node.previous != null) node.previous.next = node.next;
			if(node.next != null) node.next.previous = node.previous;
			if(this.dispatching) this.listenerNodePool.cache(node); else this.listenerNodePool.dispose(node);
			this.numListeners--;
		}
	}
	,removeAll: function() {
		while(this.head != null) {
			var node = this.head;
			this.head = this.head.next;
			this.listenerNodePool.dispose(node);
		}
		this.tail = null;
		this.toAddHead = null;
		this.toAddTail = null;
		this.numListeners = 0;
	}
	,__class__: glaze_signals_SignalBase
};
var glaze_signals_Signal0 = function() {
	glaze_signals_SignalBase.call(this);
};
glaze_signals_Signal0.__name__ = ["glaze","signals","Signal0"];
glaze_signals_Signal0.__super__ = glaze_signals_SignalBase;
glaze_signals_Signal0.prototype = $extend(glaze_signals_SignalBase.prototype,{
	dispatch: function() {
		this.startDispatch();
		var node = this.head;
		while(node != null) {
			node.listener();
			if(node.once) this.remove(node.listener);
			node = node.next;
		}
		this.endDispatch();
	}
	,__class__: glaze_signals_Signal0
});
var glaze_signals_Signal1 = function() {
	glaze_signals_SignalBase.call(this);
};
glaze_signals_Signal1.__name__ = ["glaze","signals","Signal1"];
glaze_signals_Signal1.__super__ = glaze_signals_SignalBase;
glaze_signals_Signal1.prototype = $extend(glaze_signals_SignalBase.prototype,{
	dispatch: function(object1) {
		this.startDispatch();
		var node = this.head;
		while(node != null) {
			node.listener(object1);
			if(node.once) this.remove(node.listener);
			node = node.next;
		}
		this.endDispatch();
	}
	,__class__: glaze_signals_Signal1
});
var glaze_signals_Signal2 = function() {
	glaze_signals_SignalBase.call(this);
};
glaze_signals_Signal2.__name__ = ["glaze","signals","Signal2"];
glaze_signals_Signal2.__super__ = glaze_signals_SignalBase;
glaze_signals_Signal2.prototype = $extend(glaze_signals_SignalBase.prototype,{
	dispatch: function(object1,object2) {
		this.startDispatch();
		var node = this.head;
		while(node != null) {
			node.listener(object1,object2);
			if(node.once) this.remove(node.listener);
			node = node.next;
		}
		this.endDispatch();
	}
	,__class__: glaze_signals_Signal2
});
var glaze_tmx_TmxLayer = function(source,parent) {
	this.properties = new glaze_tmx_TmxPropertySet();
	this.map = parent;
	this.name = source.att.resolve("name");
	this.x = source.has.resolve("x")?Std.parseInt(source.att.resolve("x")):0;
	this.y = source.has.resolve("y")?Std.parseInt(source.att.resolve("y")):0;
	this.width = Std.parseInt(source.att.resolve("width"));
	this.height = Std.parseInt(source.att.resolve("height"));
	this.visible = source.has.resolve("visible") && source.att.resolve("visible") == "1" && true;
	var tmp;
	if(source.has.resolve("opacity")) {
		var x = source.att.resolve("opacity");
		tmp = parseFloat(x);
	} else tmp = 0;
	this.opacity = tmp;
	var node;
	var _this = source.nodes.resolve("properties");
	var _g_head = _this.h;
	var _g_val = null;
	while(_g_head != null) {
		var tmp1;
		_g_val = _g_head[0];
		_g_head = _g_head[1];
		tmp1 = _g_val;
		var node1 = tmp1;
		this.properties.extend(node1);
	}
	var data = source.node.resolve("data");
	if(data != null) {
		var chunk = "";
		var _g = data.att.resolve("encoding");
		switch(_g) {
		case "base64":
			chunk = StringTools.trim(data.get_innerData());
			var compressed = false;
			if(data.has.resolve("compression")) {
				var _g1 = data.att.resolve("compression");
				switch(_g1) {
				case "zlib":
					compressed = true;
					break;
				default:
					throw new js__$Boot_HaxeError("TmxLayer - data compression type not supported!");
				}
			}
			this.tileGIDs = new glaze_ds_Bytes2D(this.width,this.height,32,4,glaze_ds_Bytes2D.uncompressData(chunk,compressed));
			break;
		case "csv":
			break;
		default:
		}
	}
};
glaze_tmx_TmxLayer.__name__ = ["glaze","tmx","TmxLayer"];
glaze_tmx_TmxLayer.csvToArray = function(input) {
	var result = [];
	var rows = input.split("\n");
	var _g = 0;
	while(_g < rows.length) {
		var row = rows[_g];
		++_g;
		if(row == "") continue;
		var resultRow = [];
		var entries = row.split(",");
		var _g1 = 0;
		while(_g1 < entries.length) {
			var entry = entries[_g1];
			++_g1;
			resultRow.push(Std.parseInt(entry));
		}
		result.push(resultRow);
	}
	return result;
};
glaze_tmx_TmxLayer.LayerToCoordTexture = function(layer) {
	var tileSet = null;
	var textureData = new glaze_ds_TypedArray2D(layer.width,layer.height);
	var _g1 = 0;
	var _g = layer.width;
	while(_g1 < _g) {
		var xp = _g1++;
		var _g3 = 0;
		var _g2 = layer.height;
		while(_g3 < _g2) {
			var yp = _g3++;
			var tmp;
			var _this = layer.tileGIDs;
			tmp = _this.data.b[yp * _this.internalWidth + xp * _this.bytesPerCell];
			var source = tmp;
			if(source > 0) {
				if(tileSet == null) tileSet = layer.map.getGidOwner(source);
				var relativeID = source - tileSet.firstGID;
				var y = Math.floor(relativeID / tileSet.numCols);
				var x = relativeID - tileSet.numCols * y;
				var v = -16777216 | y << 8 | x;
				textureData.data32[yp * textureData.w + xp] = v;
			} else textureData.data32[yp * textureData.w + xp] = -1;
		}
	}
	return textureData;
};
glaze_tmx_TmxLayer.prototype = {
	__class__: glaze_tmx_TmxLayer
};
var glaze_tmx_TmxMap = function(data) {
	this.properties = new glaze_tmx_TmxPropertySet();
	var source = null;
	var node = null;
	if(typeof(data) == "string") source = new haxe_xml_Fast(Xml.parse(data)); else throw new js__$Boot_HaxeError("Unknown TMX map format");
	this.tilesets = [];
	this.layers = new glaze_tmx_TmxOrderedHash();
	this.objectGroups = new glaze_tmx_TmxOrderedHash();
	source = source.node.resolve("map");
	this.version = source.att.resolve("version");
	if(this.version == null) this.version = "unknown";
	this.orientation = source.att.resolve("orientation");
	if(this.orientation == null) this.orientation = "orthogonal";
	this.width = Std.parseInt(source.att.resolve("width"));
	this.height = Std.parseInt(source.att.resolve("height"));
	this.tileWidth = Std.parseInt(source.att.resolve("tilewidth"));
	this.tileHeight = Std.parseInt(source.att.resolve("tileheight"));
	this.fullWidth = this.width * this.tileWidth;
	this.fullHeight = this.height * this.tileHeight;
	var _this = source.nodes.resolve("properties");
	var _g_head = _this.h;
	var _g_val = null;
	while(_g_head != null) {
		var tmp;
		_g_val = _g_head[0];
		_g_head = _g_head[1];
		tmp = _g_val;
		var node1 = tmp;
		this.properties.extend(node1);
	}
	var _this1 = source.nodes.resolve("tileset");
	var _g_head1 = _this1.h;
	var _g_val1 = null;
	while(_g_head1 != null) {
		var tmp1;
		_g_val1 = _g_head1[0];
		_g_head1 = _g_head1[1];
		tmp1 = _g_val1;
		var node2 = tmp1;
		this.tilesets.push(new glaze_tmx_TmxTileSet(node2));
	}
	var _this2 = source.nodes.resolve("layer");
	var _g_head2 = _this2.h;
	var _g_val2 = null;
	while(_g_head2 != null) {
		var tmp2;
		_g_val2 = _g_head2[0];
		_g_head2 = _g_head2[1];
		tmp2 = _g_val2;
		var node3 = tmp2;
		var _this3 = this.layers;
		var key = node3.att.resolve("name");
		var value = new glaze_tmx_TmxLayer(node3,this);
		var tmp3;
		var _this4 = _this3._map;
		if(__map_reserved[key] != null) tmp3 = _this4.existsReserved(key); else tmp3 = _this4.h.hasOwnProperty(key);
		if(!tmp3) _this3._keys.push(key);
		var _this5 = _this3._map;
		if(__map_reserved[key] != null) _this5.setReserved(key,value); else _this5.h[key] = value;
	}
	var _this6 = source.nodes.resolve("objectgroup");
	var _g_head3 = _this6.h;
	var _g_val3 = null;
	while(_g_head3 != null) {
		var tmp4;
		_g_val3 = _g_head3[0];
		_g_head3 = _g_head3[1];
		tmp4 = _g_val3;
		var node4 = tmp4;
		var _this7 = this.objectGroups;
		var key1 = node4.att.resolve("name");
		var value1 = new glaze_tmx_TmxObjectGroup(node4,this);
		var tmp5;
		var _this8 = _this7._map;
		if(__map_reserved[key1] != null) tmp5 = _this8.existsReserved(key1); else tmp5 = _this8.h.hasOwnProperty(key1);
		if(!tmp5) _this7._keys.push(key1);
		var _this9 = _this7._map;
		if(__map_reserved[key1] != null) _this9.setReserved(key1,value1); else _this9.h[key1] = value1;
	}
};
glaze_tmx_TmxMap.__name__ = ["glaze","tmx","TmxMap"];
glaze_tmx_TmxMap.prototype = {
	getLayer: function(name) {
		var tmp;
		var _this = this.layers._map;
		if(__map_reserved[name] != null) tmp = _this.getReserved(name); else tmp = _this.h[name];
		return tmp;
	}
	,getObjectGroup: function(name) {
		var tmp;
		var _this = this.objectGroups._map;
		if(__map_reserved[name] != null) tmp = _this.getReserved(name); else tmp = _this.h[name];
		return tmp;
	}
	,getGidOwner: function(gid) {
		var _g = 0;
		var _g1 = this.tilesets;
		while(_g < _g1.length) {
			var set = _g1[_g];
			++_g;
			if(set.hasGid(gid)) return set;
		}
		return null;
	}
	,__class__: glaze_tmx_TmxMap
};
var glaze_tmx_TmxObject = function(source,parent) {
	this.group = parent;
	this.name = source.has.resolve("name")?source.att.resolve("name"):"[object]";
	this.type = source.has.resolve("type")?source.att.resolve("type"):"";
	this.x = Std.parseInt(source.att.resolve("x"));
	this.y = Std.parseInt(source.att.resolve("y"));
	this.width = source.has.resolve("width")?Std.parseInt(source.att.resolve("width")):0;
	this.height = source.has.resolve("height")?Std.parseInt(source.att.resolve("height")):0;
	this.shared = null;
	this.gid = -1;
	if(source.has.resolve("gid") && source.att.resolve("gid").length != 0) {
		this.gid = Std.parseInt(source.att.resolve("gid"));
		var _g = 0;
		var _g1 = this.group.map.tilesets;
		while(_g < _g1.length) {
			var set = _g1[_g];
			++_g;
			this.shared = set.getPropertiesByGid(this.gid);
			if(this.shared != null) break;
		}
	}
	this.custom = new glaze_tmx_TmxPropertySet();
	var _this = source.nodes.resolve("properties");
	var _g_head = _this.h;
	var _g_val = null;
	while(_g_head != null) {
		var tmp;
		_g_val = _g_head[0];
		_g_head = _g_head[1];
		tmp = _g_val;
		var node = tmp;
		this.custom.extend(node);
	}
};
glaze_tmx_TmxObject.__name__ = ["glaze","tmx","TmxObject"];
glaze_tmx_TmxObject.prototype = {
	__class__: glaze_tmx_TmxObject
};
var glaze_tmx_TmxObjectGroup = function(source,parent) {
	this.properties = new glaze_tmx_TmxPropertySet();
	this.objects = [];
	this.map = parent;
	this.name = source.att.resolve("name");
	this.x = source.has.resolve("x")?Std.parseInt(source.att.resolve("x")):0;
	this.y = source.has.resolve("y")?Std.parseInt(source.att.resolve("y")):0;
	this.width = source.has.resolve("width")?Std.parseInt(source.att.resolve("width")):0;
	this.height = source.has.resolve("height")?Std.parseInt(source.att.resolve("height")):0;
	this.visible = source.has.resolve("visible") && source.att.resolve("visible") == "1" && true;
	var tmp;
	if(source.has.resolve("opacity")) {
		var x = source.att.resolve("opacity");
		tmp = parseFloat(x);
	} else tmp = 0;
	this.opacity = tmp;
	var node;
	var _this = source.nodes.resolve("properties");
	var _g_head = _this.h;
	var _g_val = null;
	while(_g_head != null) {
		var tmp1;
		_g_val = _g_head[0];
		_g_head = _g_head[1];
		tmp1 = _g_val;
		var node1 = tmp1;
		this.properties.extend(node1);
	}
	var _this1 = source.nodes.resolve("object");
	var _g_head1 = _this1.h;
	var _g_val1 = null;
	while(_g_head1 != null) {
		var tmp2;
		_g_val1 = _g_head1[0];
		_g_head1 = _g_head1[1];
		tmp2 = _g_val1;
		var node2 = tmp2;
		this.objects.push(new glaze_tmx_TmxObject(node2,this));
	}
};
glaze_tmx_TmxObjectGroup.__name__ = ["glaze","tmx","TmxObjectGroup"];
glaze_tmx_TmxObjectGroup.prototype = {
	__class__: glaze_tmx_TmxObjectGroup
};
var glaze_tmx_TmxOrderedHash = function() {
	this._keys = [];
	this._map = new haxe_ds_StringMap();
};
glaze_tmx_TmxOrderedHash.__name__ = ["glaze","tmx","TmxOrderedHash"];
glaze_tmx_TmxOrderedHash.prototype = {
	set: function(key,value) {
		var tmp;
		var _this = this._map;
		if(__map_reserved[key] != null) tmp = _this.existsReserved(key); else tmp = _this.h.hasOwnProperty(key);
		if(!tmp) this._keys.push(key);
		var _this1 = this._map;
		if(__map_reserved[key] != null) _this1.setReserved(key,value); else _this1.h[key] = value;
	}
	,remove: function(key) {
		HxOverrides.remove(this._keys,key);
		return this._map.remove(key);
	}
	,exists: function(key) {
		var tmp;
		var _this = this._map;
		if(__map_reserved[key] != null) tmp = _this.existsReserved(key); else tmp = _this.h.hasOwnProperty(key);
		return tmp;
	}
	,get: function(key) {
		var tmp;
		var _this = this._map;
		if(__map_reserved[key] != null) tmp = _this.getReserved(key); else tmp = _this.h[key];
		return tmp;
	}
	,iterator: function() {
		var _keys_itr = HxOverrides.iter(this._keys);
		var __map = this._map;
		return { next : function() {
			var tmp;
			var key = _keys_itr.next();
			tmp = __map_reserved[key] != null?__map.getReserved(key):__map.h[key];
			return tmp;
		}, hasNext : $bind(_keys_itr,_keys_itr.hasNext)};
	}
	,keys: function() {
		return HxOverrides.iter(this._keys);
	}
	,toString: function() {
		var __map = this._map;
		var pairs = Lambda.map(this._keys,function(x) {
			return x + " => " + Std.string(__map_reserved[x] != null?__map.getReserved(x):__map.h[x]);
		});
		return "{" + pairs.join(", ") + "}";
	}
	,__class__: glaze_tmx_TmxOrderedHash
};
var glaze_tmx_TmxPropertySet = function() {
	this.keys = new haxe_ds_StringMap();
};
glaze_tmx_TmxPropertySet.__name__ = ["glaze","tmx","TmxPropertySet"];
glaze_tmx_TmxPropertySet.prototype = {
	resolve: function(name) {
		var tmp;
		var _this = this.keys;
		if(__map_reserved[name] != null) tmp = _this.getReserved(name); else tmp = _this.h[name];
		return tmp;
	}
	,extend: function(source) {
		var prop;
		var _this = source.nodes.resolve("property");
		var _g_head = _this.h;
		var _g_val = null;
		while(_g_head != null) {
			var tmp;
			_g_val = _g_head[0];
			_g_head = _g_head[1];
			tmp = _g_val;
			var prop1 = tmp;
			var key = prop1.att.resolve("name");
			var value = prop1.att.resolve("value");
			var _this1 = this.keys;
			if(__map_reserved[key] != null) _this1.setReserved(key,value); else _this1.h[key] = value;
		}
	}
	,__class__: glaze_tmx_TmxPropertySet
};
var glaze_tmx_TmxTileSet = function(data) {
	var source;
	this.numTiles = 16777215;
	this.numRows = this.numCols = 1;
	if(js_Boot.__instanceof(data,haxe_xml_Fast)) source = data; else throw new js__$Boot_HaxeError("Unknown TMX tileset format");
	this.firstGID = source.has.resolve("firstgid")?Std.parseInt(source.att.resolve("firstgid")):1;
	if(source.has.resolve("source")) {
	} else {
		var node = source.node.resolve("image");
		this.imageSource = node.att.resolve("source");
		this.name = source.att.resolve("name");
		if(source.has.resolve("tilewidth")) this.tileWidth = Std.parseInt(source.att.resolve("tilewidth"));
		if(source.has.resolve("tileheight")) this.tileHeight = Std.parseInt(source.att.resolve("tileheight"));
		if(source.has.resolve("spacing")) this.spacing = Std.parseInt(source.att.resolve("spacing"));
		if(source.has.resolve("margin")) this.margin = Std.parseInt(source.att.resolve("margin"));
		this._tileProps = [];
		var _this = source.nodes.resolve("tile");
		var _g_head = _this.h;
		var _g_val = null;
		while(_g_head != null) {
			var tmp;
			_g_val = _g_head[0];
			_g_head = _g_head[1];
			tmp = _g_val;
			var node1 = tmp;
			if(node1.has.resolve("id")) {
				var id = Std.parseInt(node1.att.resolve("id"));
				this._tileProps[id] = new glaze_tmx_TmxPropertySet();
				var _this1 = node1.nodes.resolve("properties");
				var _g_head1 = _this1.h;
				var _g_val1 = null;
				while(_g_head1 != null) {
					var tmp1;
					_g_val1 = _g_head1[0];
					_g_head1 = _g_head1[1];
					tmp1 = _g_val1;
					var prop = tmp1;
					this._tileProps[id].extend(prop);
				}
			}
		}
	}
};
glaze_tmx_TmxTileSet.__name__ = ["glaze","tmx","TmxTileSet"];
glaze_tmx_TmxTileSet.prototype = {
	get_image: function() {
		return this._image;
	}
	,set_image: function(v) {
		this._image = v;
		this.numCols = Math.floor(v.width / this.tileWidth);
		this.numRows = Math.floor(v.height / this.tileHeight);
		this.numTiles = this.numRows * this.numCols;
		return this._image;
	}
	,hasGid: function(gid) {
		return gid >= this.firstGID && gid < this.firstGID + this.numTiles;
	}
	,fromGid: function(gid) {
		return gid - this.firstGID;
	}
	,toGid: function(id) {
		return this.firstGID + id;
	}
	,getPropertiesByGid: function(gid) {
		if(this._tileProps != null) return this._tileProps[gid - this.firstGID];
		return null;
	}
	,getProperties: function(id) {
		return this._tileProps[id];
	}
	,getRect: function(id) {
		return new glaze_geom_Rectangle(0,0,id % this.numCols * this.tileWidth,id / this.numCols * this.tileHeight);
	}
	,__class__: glaze_tmx_TmxTileSet
};
var glaze_util_AssetLoader = function() {
	this.assets = new haxe_ds_StringMap();
	this.loaded = new glaze_signals_Signal0();
	this.Reset();
};
glaze_util_AssetLoader.__name__ = ["glaze","util","AssetLoader"];
glaze_util_AssetLoader.prototype = {
	Reset: function() {
		this.running = false;
		this.loaders = [];
	}
	,SetImagesToLoad: function(urls) {
		var _g = 0;
		while(_g < urls.length) {
			var url = urls[_g];
			++_g;
			this.AddAsset(url);
		}
	}
	,AddAsset: function(url) {
		if(this.running == true) return;
		var loader = this.LoaderFactory(url);
		loader.Init(url);
		this.loaders.push(loader);
	}
	,LoaderFactory: function(url) {
		var extention = url.substring(url.length - 3,url.length);
		if(extention == "png") return new glaze_util_ImageAsset(this);
		if(extention == "tmx" || extention == "xml" || extention == "son") return new glaze_util_BlobAsset(this);
		return null;
	}
	,Load: function() {
		if(this.running == true || this.loaders.length == 0) return;
		this.completeCount = this.loaders.length;
		this.running = true;
		var _g = 0;
		var _g1 = this.loaders;
		while(_g < _g1.length) {
			var loader = _g1[_g];
			++_g;
			loader.Load();
		}
	}
	,onLoad: function(item) {
		this.completeCount--;
		var _this = this.assets;
		var key = item.getKey();
		var value = item.getValue();
		if(__map_reserved[key] != null) _this.setReserved(key,value); else _this.h[key] = value;
		if(this.completeCount == 0) {
			this.loaded.dispatch();
			this.running = false;
		}
	}
	,__class__: glaze_util_AssetLoader
};
var glaze_util_ILoader = function() { };
glaze_util_ILoader.__name__ = ["glaze","util","ILoader"];
glaze_util_ILoader.prototype = {
	__class__: glaze_util_ILoader
};
var glaze_util_ImageAsset = function(mgr) {
	this.mgr = mgr;
};
glaze_util_ImageAsset.__name__ = ["glaze","util","ImageAsset"];
glaze_util_ImageAsset.__interfaces__ = [glaze_util_ILoader];
glaze_util_ImageAsset.prototype = {
	Init: function(url) {
		this.url = url;
		this.image = new Image();
		this.image.onload = $bind(this,this.onLoad);
		this.image.crossOrigin = "anonymous";
	}
	,Load: function() {
		this.image.src = this.url;
		if(this.image.complete == true) this.onLoad(null);
	}
	,onLoad: function(event) {
		if(this.mgr != null) this.mgr.onLoad(this);
	}
	,getKey: function() {
		return this.url;
	}
	,getValue: function() {
		return this.image;
	}
	,__class__: glaze_util_ImageAsset
};
var glaze_util_BlobAsset = function(mgr) {
	this.mgr = mgr;
};
glaze_util_BlobAsset.__name__ = ["glaze","util","BlobAsset"];
glaze_util_BlobAsset.__interfaces__ = [glaze_util_ILoader];
glaze_util_BlobAsset.prototype = {
	Init: function(url) {
		this.url = url;
		this.xhr = new XMLHttpRequest();
		this.xhr.open("GET",url,true);
		this.xhr.responseType = "text";
		this.xhr.onload = $bind(this,this.onLoad);
	}
	,Load: function() {
		this.xhr.send();
	}
	,onLoad: function(event) {
		if(this.mgr != null) this.mgr.onLoad(this);
	}
	,getKey: function() {
		return this.url;
	}
	,getValue: function() {
		return this.xhr.response;
	}
	,__class__: glaze_util_BlobAsset
};
var glaze_util_Random = function() { };
glaze_util_Random.__name__ = ["glaze","util","Random"];
glaze_util_Random.SetPseudoRandomSeed = function(seed) {
	glaze_util_Random.PseudoRandomSeed = seed;
};
glaze_util_Random.RandomFloat = function(min,max) {
	return Math.random() * (max - min) + min;
};
glaze_util_Random.RandomBoolean = function(chance) {
	if(chance == null) chance = 0.5;
	return Math.random() < chance;
};
glaze_util_Random.RandomSign = function(chance) {
	if(chance == null) chance = 0.5;
	return Math.random() < chance?1:-1;
};
glaze_util_Random.RandomInteger = function(min,max) {
	return Math.floor(Math.random() * (max - min) + min);
};
glaze_util_Random.PseudoFloat = function() {
	glaze_util_Random.PseudoRandomSeed = (glaze_util_Random.PseudoRandomSeed * 9301 + 49297) % 233280;
	return glaze_util_Random.PseudoRandomSeed / 233280.0;
};
var haxe_IMap = function() { };
haxe_IMap.__name__ = ["haxe","IMap"];
var haxe__$Int64__$_$_$Int64 = function(high,low) {
	this.high = high;
	this.low = low;
};
haxe__$Int64__$_$_$Int64.__name__ = ["haxe","_Int64","___Int64"];
haxe__$Int64__$_$_$Int64.prototype = {
	__class__: haxe__$Int64__$_$_$Int64
};
var haxe_crypto_Adler32 = function() {
	this.a1 = 1;
	this.a2 = 0;
};
haxe_crypto_Adler32.__name__ = ["haxe","crypto","Adler32"];
haxe_crypto_Adler32.read = function(i) {
	var a = new haxe_crypto_Adler32();
	var a2a = i.readByte();
	var a2b = i.readByte();
	var a1a = i.readByte();
	var a1b = i.readByte();
	a.a1 = a1a << 8 | a1b;
	a.a2 = a2a << 8 | a2b;
	return a;
};
haxe_crypto_Adler32.prototype = {
	update: function(b,pos,len) {
		var a1 = this.a1;
		var a2 = this.a2;
		var _g1 = pos;
		var _g = pos + len;
		while(_g1 < _g) {
			var p = _g1++;
			var c = b.b[p];
			a1 = (a1 + c) % 65521;
			a2 = (a2 + a1) % 65521;
		}
		this.a1 = a1;
		this.a2 = a2;
	}
	,equals: function(a) {
		return a.a1 == this.a1 && a.a2 == this.a2;
	}
	,__class__: haxe_crypto_Adler32
};
var haxe_io_Bytes = function(data) {
	this.length = data.byteLength;
	this.b = new Uint8Array(data);
	this.b.bufferValue = data;
	data.hxBytes = this;
	data.bytes = this.b;
};
haxe_io_Bytes.__name__ = ["haxe","io","Bytes"];
haxe_io_Bytes.alloc = function(length) {
	return new haxe_io_Bytes(new ArrayBuffer(length));
};
haxe_io_Bytes.ofString = function(s) {
	var a = [];
	var i = 0;
	while(i < s.length) {
		var tmp;
		var index = i++;
		tmp = s.charCodeAt(index);
		var c = tmp;
		if(55296 <= c && c <= 56319) {
			var tmp1;
			var index1 = i++;
			tmp1 = s.charCodeAt(index1);
			c = c - 55232 << 10 | tmp1 & 1023;
		}
		if(c <= 127) a.push(c); else if(c <= 2047) {
			a.push(192 | c >> 6);
			a.push(128 | c & 63);
		} else if(c <= 65535) {
			a.push(224 | c >> 12);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		} else {
			a.push(240 | c >> 18);
			a.push(128 | c >> 12 & 63);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		}
	}
	return new haxe_io_Bytes(new Uint8Array(a).buffer);
};
haxe_io_Bytes.prototype = {
	blit: function(pos,src,srcpos,len) {
		if(pos < 0 || srcpos < 0 || len < 0 || pos + len > this.length || srcpos + len > src.length) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
		if(srcpos == 0 && len == src.length) this.b.set(src.b,pos); else this.b.set(src.b.subarray(srcpos,srcpos + len),pos);
	}
	,__class__: haxe_io_Bytes
};
var haxe_crypto_Base64 = function() { };
haxe_crypto_Base64.__name__ = ["haxe","crypto","Base64"];
haxe_crypto_Base64.decode = function(str,complement) {
	if(complement == null) complement = true;
	if(complement) while(HxOverrides.cca(str,str.length - 1) == 61) str = HxOverrides.substr(str,0,-1);
	return new haxe_crypto_BaseCode(haxe_crypto_Base64.BYTES).decodeBytes(haxe_io_Bytes.ofString(str));
};
var haxe_crypto_BaseCode = function(base) {
	var len = base.length;
	var nbits = 1;
	while(len > 1 << nbits) nbits++;
	if(nbits > 8 || len != 1 << nbits) throw new js__$Boot_HaxeError("BaseCode : base length must be a power of two.");
	this.base = base;
	this.nbits = nbits;
};
haxe_crypto_BaseCode.__name__ = ["haxe","crypto","BaseCode"];
haxe_crypto_BaseCode.prototype = {
	initTable: function() {
		var tbl = [];
		var _g = 0;
		while(_g < 256) {
			var i = _g++;
			tbl[i] = -1;
		}
		var _g1 = 0;
		var _g2 = this.base.length;
		while(_g1 < _g2) {
			var i1 = _g1++;
			tbl[this.base.b[i1]] = i1;
		}
		this.tbl = tbl;
	}
	,decodeBytes: function(b) {
		var nbits = this.nbits;
		if(this.tbl == null) this.initTable();
		var tbl = this.tbl;
		var size = b.length * nbits >> 3;
		var out = haxe_io_Bytes.alloc(size);
		var buf = 0;
		var curbits = 0;
		var pin = 0;
		var pout = 0;
		while(pout < size) {
			while(curbits < 8) {
				curbits += nbits;
				buf <<= nbits;
				var tmp;
				var pos = pin++;
				tmp = b.b[pos];
				var i = tbl[tmp];
				if(i == -1) throw new js__$Boot_HaxeError("BaseCode : invalid encoded char");
				buf |= i;
			}
			curbits -= 8;
			var pos1 = pout++;
			out.b[pos1] = buf >> curbits & 255 & 255;
		}
		return out;
	}
	,__class__: haxe_crypto_BaseCode
};
var haxe_ds_IntMap = function() {
	this.h = { };
};
haxe_ds_IntMap.__name__ = ["haxe","ds","IntMap"];
haxe_ds_IntMap.__interfaces__ = [haxe_IMap];
haxe_ds_IntMap.prototype = {
	__class__: haxe_ds_IntMap
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
haxe_ds_StringMap.__name__ = ["haxe","ds","StringMap"];
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	setReserved: function(key,value) {
		if(this.rh == null) this.rh = { };
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		return this.rh == null?null:this.rh["$" + key];
	}
	,existsReserved: function(key) {
		if(this.rh == null) return false;
		return this.rh.hasOwnProperty("$" + key);
	}
	,remove: function(key) {
		if(__map_reserved[key] != null) {
			key = "$" + key;
			if(this.rh == null || !this.rh.hasOwnProperty(key)) return false;
			delete(this.rh[key]);
			return true;
		} else {
			if(!this.h.hasOwnProperty(key)) return false;
			delete(this.h[key]);
			return true;
		}
	}
	,__class__: haxe_ds_StringMap
};
var haxe_io_BytesBuffer = function() {
	this.b = [];
};
haxe_io_BytesBuffer.__name__ = ["haxe","io","BytesBuffer"];
haxe_io_BytesBuffer.prototype = {
	getBytes: function() {
		var bytes = new haxe_io_Bytes(new Uint8Array(this.b).buffer);
		this.b = null;
		return bytes;
	}
	,__class__: haxe_io_BytesBuffer
};
var haxe_io_Input = function() { };
haxe_io_Input.__name__ = ["haxe","io","Input"];
haxe_io_Input.prototype = {
	readByte: function() {
		throw new js__$Boot_HaxeError("Not implemented");
	}
	,readBytes: function(s,pos,len) {
		var k = len;
		var b = s.b;
		if(pos < 0 || len < 0 || pos + len > s.length) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
		while(k > 0) {
			b[pos] = this.readByte();
			pos++;
			k--;
		}
		return len;
	}
	,read: function(nbytes) {
		var s = haxe_io_Bytes.alloc(nbytes);
		var p = 0;
		while(nbytes > 0) {
			var k = this.readBytes(s,p,nbytes);
			if(k == 0) throw new js__$Boot_HaxeError(haxe_io_Error.Blocked);
			p += k;
			nbytes -= k;
		}
		return s;
	}
	,readUInt16: function() {
		var ch1 = this.readByte();
		var ch2 = this.readByte();
		return this.bigEndian?ch2 | ch1 << 8:ch1 | ch2 << 8;
	}
	,__class__: haxe_io_Input
};
var haxe_io_BytesInput = function(b,pos,len) {
	if(pos == null) pos = 0;
	if(len == null) len = b.length - pos;
	if(pos < 0 || len < 0 || pos + len > b.length) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
	this.b = b.b;
	this.pos = pos;
	this.len = len;
	this.totlen = len;
};
haxe_io_BytesInput.__name__ = ["haxe","io","BytesInput"];
haxe_io_BytesInput.__super__ = haxe_io_Input;
haxe_io_BytesInput.prototype = $extend(haxe_io_Input.prototype,{
	readByte: function() {
		if(this.len == 0) throw new js__$Boot_HaxeError(new haxe_io_Eof());
		this.len--;
		return this.b[this.pos++];
	}
	,readBytes: function(buf,pos,len) {
		if(pos < 0 || len < 0 || pos + len > buf.length) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
		if(this.len == 0 && len > 0) throw new js__$Boot_HaxeError(new haxe_io_Eof());
		if(this.len < len) len = this.len;
		var b1 = this.b;
		var b2 = buf.b;
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			b2[pos + i] = b1[this.pos + i];
		}
		this.pos += len;
		this.len -= len;
		return len;
	}
	,__class__: haxe_io_BytesInput
});
var haxe_io_Eof = function() {
};
haxe_io_Eof.__name__ = ["haxe","io","Eof"];
haxe_io_Eof.prototype = {
	toString: function() {
		return "Eof";
	}
	,__class__: haxe_io_Eof
};
var haxe_io_Error = { __ename__ : true, __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] };
haxe_io_Error.Blocked = ["Blocked",0];
haxe_io_Error.Blocked.toString = $estr;
haxe_io_Error.Blocked.__enum__ = haxe_io_Error;
haxe_io_Error.Overflow = ["Overflow",1];
haxe_io_Error.Overflow.toString = $estr;
haxe_io_Error.Overflow.__enum__ = haxe_io_Error;
haxe_io_Error.OutsideBounds = ["OutsideBounds",2];
haxe_io_Error.OutsideBounds.toString = $estr;
haxe_io_Error.OutsideBounds.__enum__ = haxe_io_Error;
haxe_io_Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe_io_Error; $x.toString = $estr; return $x; };
var haxe_io_FPHelper = function() { };
haxe_io_FPHelper.__name__ = ["haxe","io","FPHelper"];
haxe_io_FPHelper.i32ToFloat = function(i) {
	var sign = 1 - (i >>> 31 << 1);
	var exp = i >>> 23 & 255;
	var sig = i & 8388607;
	if(sig == 0 && exp == 0) return 0.0;
	return sign * (1 + Math.pow(2,-23) * sig) * Math.pow(2,exp - 127);
};
haxe_io_FPHelper.floatToI32 = function(f) {
	if(f == 0) return 0;
	var af = f < 0?-f:f;
	var exp = Math.floor(Math.log(af) / 0.6931471805599453);
	if(exp < -127) exp = -127; else if(exp > 128) exp = 128;
	var sig = Math.round((af / Math.pow(2,exp) - 1) * 8388608) & 8388607;
	return (f < 0?-2147483648:0) | exp + 127 << 23 | sig;
};
haxe_io_FPHelper.i64ToDouble = function(low,high) {
	var sign = 1 - (high >>> 31 << 1);
	var exp = (high >> 20 & 2047) - 1023;
	var sig = (high & 1048575) * 4294967296. + (low >>> 31) * 2147483648. + (low & 2147483647);
	if(sig == 0 && exp == -1023) return 0.0;
	return sign * (1.0 + Math.pow(2,-52) * sig) * Math.pow(2,exp);
};
haxe_io_FPHelper.doubleToI64 = function(v) {
	var i64 = haxe_io_FPHelper.i64tmp;
	if(v == 0) {
		i64.low = 0;
		i64.high = 0;
	} else {
		var av = v < 0?-v:v;
		var exp = Math.floor(Math.log(av) / 0.6931471805599453);
		var tmp;
		var v1 = (av / Math.pow(2,exp) - 1) * 4503599627370496.;
		tmp = Math.round(v1);
		var sig = tmp;
		var sig_l = sig | 0;
		var sig_h = sig / 4294967296.0 | 0;
		i64.low = sig_l;
		i64.high = (v < 0?-2147483648:0) | exp + 1023 << 20 | sig_h;
	}
	return i64;
};
var haxe_xml__$Fast_NodeAccess = function(x) {
	this.__x = x;
};
haxe_xml__$Fast_NodeAccess.__name__ = ["haxe","xml","_Fast","NodeAccess"];
haxe_xml__$Fast_NodeAccess.prototype = {
	resolve: function(name) {
		var x = this.__x.elementsNamed(name).next();
		if(x == null) {
			var tmp;
			if(this.__x.nodeType == Xml.Document) tmp = "Document"; else {
				var _this = this.__x;
				if(_this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + _this.nodeType);
				tmp = _this.nodeName;
			}
			var xname = tmp;
			throw new js__$Boot_HaxeError(xname + " is missing element " + name);
		}
		return new haxe_xml_Fast(x);
	}
	,__class__: haxe_xml__$Fast_NodeAccess
};
var haxe_xml__$Fast_AttribAccess = function(x) {
	this.__x = x;
};
haxe_xml__$Fast_AttribAccess.__name__ = ["haxe","xml","_Fast","AttribAccess"];
haxe_xml__$Fast_AttribAccess.prototype = {
	resolve: function(name) {
		if(this.__x.nodeType == Xml.Document) throw new js__$Boot_HaxeError("Cannot access document attribute " + name);
		var v = this.__x.get(name);
		if(v == null) {
			var tmp;
			var _this = this.__x;
			if(_this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + _this.nodeType);
			tmp = _this.nodeName;
			throw new js__$Boot_HaxeError(tmp + " is missing attribute " + name);
		}
		return v;
	}
	,__class__: haxe_xml__$Fast_AttribAccess
};
var haxe_xml__$Fast_HasAttribAccess = function(x) {
	this.__x = x;
};
haxe_xml__$Fast_HasAttribAccess.__name__ = ["haxe","xml","_Fast","HasAttribAccess"];
haxe_xml__$Fast_HasAttribAccess.prototype = {
	resolve: function(name) {
		if(this.__x.nodeType == Xml.Document) throw new js__$Boot_HaxeError("Cannot access document attribute " + name);
		return this.__x.exists(name);
	}
	,__class__: haxe_xml__$Fast_HasAttribAccess
};
var haxe_xml__$Fast_HasNodeAccess = function(x) {
	this.__x = x;
};
haxe_xml__$Fast_HasNodeAccess.__name__ = ["haxe","xml","_Fast","HasNodeAccess"];
haxe_xml__$Fast_HasNodeAccess.prototype = {
	__class__: haxe_xml__$Fast_HasNodeAccess
};
var haxe_xml__$Fast_NodeListAccess = function(x) {
	this.__x = x;
};
haxe_xml__$Fast_NodeListAccess.__name__ = ["haxe","xml","_Fast","NodeListAccess"];
haxe_xml__$Fast_NodeListAccess.prototype = {
	resolve: function(name) {
		var l = new List();
		var $it0 = this.__x.elementsNamed(name);
		while( $it0.hasNext() ) {
			var x = $it0.next();
			l.add(new haxe_xml_Fast(x));
		}
		return l;
	}
	,__class__: haxe_xml__$Fast_NodeListAccess
};
var haxe_xml_Fast = function(x) {
	if(x.nodeType != Xml.Document && x.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Invalid nodeType " + x.nodeType);
	this.x = x;
	this.node = new haxe_xml__$Fast_NodeAccess(x);
	this.nodes = new haxe_xml__$Fast_NodeListAccess(x);
	this.att = new haxe_xml__$Fast_AttribAccess(x);
	this.has = new haxe_xml__$Fast_HasAttribAccess(x);
	this.hasNode = new haxe_xml__$Fast_HasNodeAccess(x);
};
haxe_xml_Fast.__name__ = ["haxe","xml","Fast"];
haxe_xml_Fast.prototype = {
	get_name: function() {
		var tmp;
		if(this.x.nodeType == Xml.Document) tmp = "Document"; else {
			var _this = this.x;
			if(_this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + _this.nodeType);
			tmp = _this.nodeName;
		}
		return tmp;
	}
	,get_innerData: function() {
		var tmp;
		var _this = this.x;
		if(_this.nodeType != Xml.Document && _this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + _this.nodeType);
		tmp = HxOverrides.iter(_this.children);
		var it = tmp;
		if(!it.hasNext()) throw new js__$Boot_HaxeError(this.get_name() + " does not have data");
		var v = it.next();
		var n = it.next();
		if(n != null) {
			var tmp2;
			if(v.nodeType == Xml.PCData && n.nodeType == Xml.CData) {
				var tmp3;
				var tmp4;
				if(!(v.nodeType == Xml.Document)) tmp4 = v.nodeType == Xml.Element; else tmp4 = true;
				if(tmp4) throw new js__$Boot_HaxeError("Bad node type, unexpected " + v.nodeType);
				tmp3 = v.nodeValue;
				tmp2 = StringTools.trim(tmp3) == "";
			} else tmp2 = false;
			if(tmp2) {
				var n2 = it.next();
				var tmp5;
				if(!(n2 == null)) {
					var tmp6;
					if(n2.nodeType == Xml.PCData) {
						var tmp7;
						var tmp8;
						if(!(n2.nodeType == Xml.Document)) tmp8 = n2.nodeType == Xml.Element; else tmp8 = true;
						if(tmp8) throw new js__$Boot_HaxeError("Bad node type, unexpected " + n2.nodeType);
						tmp7 = n2.nodeValue;
						tmp6 = StringTools.trim(tmp7) == "";
					} else tmp6 = false;
					if(tmp6) tmp5 = it.next() == null; else tmp5 = false;
				} else tmp5 = true;
				if(tmp5) {
					var tmp9;
					if(n.nodeType == Xml.Document || n.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + n.nodeType);
					tmp9 = n.nodeValue;
					return tmp9;
				}
			}
			throw new js__$Boot_HaxeError(this.get_name() + " does not only have data");
		}
		if(v.nodeType != Xml.PCData && v.nodeType != Xml.CData) throw new js__$Boot_HaxeError(this.get_name() + " does not have data");
		var tmp1;
		if(v.nodeType == Xml.Document || v.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + v.nodeType);
		tmp1 = v.nodeValue;
		return tmp1;
	}
	,__class__: haxe_xml_Fast
};
var haxe_xml_Parser = function() { };
haxe_xml_Parser.__name__ = ["haxe","xml","Parser"];
haxe_xml_Parser.parse = function(str,strict) {
	if(strict == null) strict = false;
	var doc = Xml.createDocument();
	haxe_xml_Parser.doParse(str,strict,0,doc);
	return doc;
};
haxe_xml_Parser.doParse = function(str,strict,p,parent) {
	if(p == null) p = 0;
	var xml = null;
	var state = 1;
	var next = 1;
	var aname = null;
	var start = 0;
	var nsubs = 0;
	var nbrackets = 0;
	var c = str.charCodeAt(p);
	var buf = new StringBuf();
	var escapeNext = 1;
	var attrValQuote = -1;
	while(!(c != c)) {
		switch(state) {
		case 0:
			switch(c) {
			case 10:case 13:case 9:case 32:
				break;
			default:
				state = next;
				continue;
			}
			break;
		case 1:
			switch(c) {
			case 60:
				state = 0;
				next = 2;
				break;
			default:
				start = p;
				state = 13;
				continue;
			}
			break;
		case 13:
			if(c == 60) {
				var len = p - start;
				buf.b += len == null?HxOverrides.substr(str,start,null):HxOverrides.substr(str,start,len);
				var child = Xml.createPCData(buf.b);
				buf = new StringBuf();
				parent.addChild(child);
				nsubs++;
				state = 0;
				next = 2;
			} else if(c == 38) {
				var len1 = p - start;
				buf.b += len1 == null?HxOverrides.substr(str,start,null):HxOverrides.substr(str,start,len1);
				state = 18;
				escapeNext = 13;
				start = p + 1;
			}
			break;
		case 17:
			if(c == 93 && str.charCodeAt(p + 1) == 93 && str.charCodeAt(p + 2) == 62) {
				var child1 = Xml.createCData(HxOverrides.substr(str,start,p - start));
				parent.addChild(child1);
				nsubs++;
				p += 2;
				state = 1;
			}
			break;
		case 2:
			switch(c) {
			case 33:
				if(str.charCodeAt(p + 1) == 91) {
					p += 2;
					if(HxOverrides.substr(str,p,6).toUpperCase() != "CDATA[") throw new js__$Boot_HaxeError("Expected <![CDATA[");
					p += 5;
					state = 17;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) == 68 || str.charCodeAt(p + 1) == 100) {
					if(HxOverrides.substr(str,p + 2,6).toUpperCase() != "OCTYPE") throw new js__$Boot_HaxeError("Expected <!DOCTYPE");
					p += 8;
					state = 16;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) != 45 || str.charCodeAt(p + 2) != 45) throw new js__$Boot_HaxeError("Expected <!--"); else {
					p += 2;
					state = 15;
					start = p + 1;
				}
				break;
			case 63:
				state = 14;
				start = p;
				break;
			case 47:
				if(parent == null) throw new js__$Boot_HaxeError("Expected node name");
				start = p + 1;
				state = 0;
				next = 10;
				break;
			default:
				state = 3;
				start = p;
				continue;
			}
			break;
		case 3:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(p == start) throw new js__$Boot_HaxeError("Expected node name");
				xml = Xml.createElement(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml);
				nsubs++;
				state = 0;
				next = 4;
				continue;
			}
			break;
		case 4:
			switch(c) {
			case 47:
				state = 11;
				break;
			case 62:
				state = 9;
				break;
			default:
				state = 5;
				start = p;
				continue;
			}
			break;
		case 5:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				var tmp1;
				if(start == p) throw new js__$Boot_HaxeError("Expected attribute name");
				tmp1 = HxOverrides.substr(str,start,p - start);
				aname = tmp1;
				if(xml.exists(aname)) throw new js__$Boot_HaxeError("Duplicate attribute");
				state = 0;
				next = 6;
				continue;
			}
			break;
		case 6:
			switch(c) {
			case 61:
				state = 0;
				next = 7;
				break;
			default:
				throw new js__$Boot_HaxeError("Expected =");
			}
			break;
		case 7:
			switch(c) {
			case 34:case 39:
				buf = new StringBuf();
				state = 8;
				start = p + 1;
				attrValQuote = c;
				break;
			default:
				throw new js__$Boot_HaxeError("Expected \"");
			}
			break;
		case 8:
			switch(c) {
			case 38:
				var len2 = p - start;
				buf.b += len2 == null?HxOverrides.substr(str,start,null):HxOverrides.substr(str,start,len2);
				state = 18;
				escapeNext = 8;
				start = p + 1;
				break;
			case 62:
				if(strict) throw new js__$Boot_HaxeError("Invalid unescaped " + String.fromCharCode(c) + " in attribute value"); else if(c == attrValQuote) {
					var len3 = p - start;
					buf.b += len3 == null?HxOverrides.substr(str,start,null):HxOverrides.substr(str,start,len3);
					var val = buf.b;
					buf = new StringBuf();
					xml.set(aname,val);
					state = 0;
					next = 4;
				}
				break;
			case 60:
				if(strict) throw new js__$Boot_HaxeError("Invalid unescaped " + String.fromCharCode(c) + " in attribute value"); else if(c == attrValQuote) {
					var len4 = p - start;
					buf.b += len4 == null?HxOverrides.substr(str,start,null):HxOverrides.substr(str,start,len4);
					var val1 = buf.b;
					buf = new StringBuf();
					xml.set(aname,val1);
					state = 0;
					next = 4;
				}
				break;
			default:
				if(c == attrValQuote) {
					var len5 = p - start;
					buf.b += len5 == null?HxOverrides.substr(str,start,null):HxOverrides.substr(str,start,len5);
					var val2 = buf.b;
					buf = new StringBuf();
					xml.set(aname,val2);
					state = 0;
					next = 4;
				}
			}
			break;
		case 9:
			p = haxe_xml_Parser.doParse(str,strict,p,xml);
			start = p;
			state = 1;
			break;
		case 11:
			switch(c) {
			case 62:
				state = 1;
				break;
			default:
				throw new js__$Boot_HaxeError("Expected >");
			}
			break;
		case 12:
			switch(c) {
			case 62:
				if(nsubs == 0) parent.addChild(Xml.createPCData(""));
				return p;
			default:
				throw new js__$Boot_HaxeError("Expected >");
			}
			break;
		case 10:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(start == p) throw new js__$Boot_HaxeError("Expected node name");
				var v = HxOverrides.substr(str,start,p - start);
				var tmp2;
				if(parent.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + parent.nodeType);
				tmp2 = parent.nodeName;
				if(v != tmp2) {
					var tmp3;
					if(parent.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + parent.nodeType);
					tmp3 = parent.nodeName;
					throw new js__$Boot_HaxeError("Expected </" + tmp3 + ">");
				}
				state = 0;
				next = 12;
				continue;
			}
			break;
		case 15:
			if(c == 45 && str.charCodeAt(p + 1) == 45 && str.charCodeAt(p + 2) == 62) {
				var xml1 = Xml.createComment(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml1);
				nsubs++;
				p += 2;
				state = 1;
			}
			break;
		case 16:
			if(c == 91) nbrackets++; else if(c == 93) nbrackets--; else if(c == 62 && nbrackets == 0) {
				var xml2 = Xml.createDocType(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml2);
				nsubs++;
				state = 1;
			}
			break;
		case 14:
			if(c == 63 && str.charCodeAt(p + 1) == 62) {
				p++;
				var str1 = HxOverrides.substr(str,start + 1,p - start - 2);
				var xml3 = Xml.createProcessingInstruction(str1);
				parent.addChild(xml3);
				nsubs++;
				state = 1;
			}
			break;
		case 18:
			if(c == 59) {
				var s = HxOverrides.substr(str,start,p - start);
				if(s.charCodeAt(0) == 35) {
					var c1 = s.charCodeAt(1) == 120?Std.parseInt("0" + HxOverrides.substr(s,1,s.length - 1)):Std.parseInt(HxOverrides.substr(s,1,s.length - 1));
					buf.b += String.fromCharCode(c1);
				} else {
					var tmp4;
					var _this = haxe_xml_Parser.escapes;
					if(__map_reserved[s] != null) tmp4 = _this.existsReserved(s); else tmp4 = _this.h.hasOwnProperty(s);
					if(!tmp4) {
						if(strict) throw new js__$Boot_HaxeError("Undefined entity: " + s);
						buf.b += Std.string("&" + s + ";");
					} else {
						var tmp5;
						var _this1 = haxe_xml_Parser.escapes;
						if(__map_reserved[s] != null) tmp5 = _this1.getReserved(s); else tmp5 = _this1.h[s];
						var x = tmp5;
						buf.b += x == null?"null":"" + x;
					}
				}
				start = p + 1;
				state = escapeNext;
			} else if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45) && c != 35) {
				if(strict) throw new js__$Boot_HaxeError("Invalid character in entity: " + String.fromCharCode(c));
				buf.b += "&";
				var len6 = p - start;
				buf.b += len6 == null?HxOverrides.substr(str,start,null):HxOverrides.substr(str,start,len6);
				p--;
				start = p + 1;
				state = escapeNext;
			}
			break;
		}
		var tmp;
		var index = ++p;
		tmp = str.charCodeAt(index);
		c = tmp;
	}
	if(state == 1) {
		start = p;
		state = 13;
	}
	if(state == 13) {
		if(p != start || nsubs == 0) {
			var len7 = p - start;
			buf.b += len7 == null?HxOverrides.substr(str,start,null):HxOverrides.substr(str,start,len7);
			var xml4 = Xml.createPCData(buf.b);
			parent.addChild(xml4);
			nsubs++;
		}
		return p;
	}
	if(!strict && state == 18 && escapeNext == 13) {
		buf.b += "&";
		var len8 = p - start;
		buf.b += len8 == null?HxOverrides.substr(str,start,null):HxOverrides.substr(str,start,len8);
		var xml5 = Xml.createPCData(buf.b);
		parent.addChild(xml5);
		nsubs++;
		return p;
	}
	throw new js__$Boot_HaxeError("Unexpected end");
};
var haxe_zip_Huffman = { __ename__ : true, __constructs__ : ["Found","NeedBit","NeedBits"] };
haxe_zip_Huffman.Found = function(i) { var $x = ["Found",0,i]; $x.__enum__ = haxe_zip_Huffman; $x.toString = $estr; return $x; };
haxe_zip_Huffman.NeedBit = function(left,right) { var $x = ["NeedBit",1,left,right]; $x.__enum__ = haxe_zip_Huffman; $x.toString = $estr; return $x; };
haxe_zip_Huffman.NeedBits = function(n,table) { var $x = ["NeedBits",2,n,table]; $x.__enum__ = haxe_zip_Huffman; $x.toString = $estr; return $x; };
var haxe_zip_HuffTools = function() {
};
haxe_zip_HuffTools.__name__ = ["haxe","zip","HuffTools"];
haxe_zip_HuffTools.prototype = {
	treeDepth: function(t) {
		var tmp;
		switch(t[1]) {
		case 0:
			tmp = 0;
			break;
		case 2:
			throw new js__$Boot_HaxeError("assert");
			break;
		case 1:
			var da = this.treeDepth(t[2]);
			var db = this.treeDepth(t[3]);
			tmp = 1 + (da < db?da:db);
			break;
		}
		return tmp;
	}
	,treeCompress: function(t) {
		var d = this.treeDepth(t);
		if(d == 0) return t;
		if(d == 1) {
			var tmp;
			switch(t[1]) {
			case 1:
				tmp = haxe_zip_Huffman.NeedBit(this.treeCompress(t[2]),this.treeCompress(t[3]));
				break;
			default:
				throw new js__$Boot_HaxeError("assert");
			}
			return tmp;
		}
		var size = 1 << d;
		var table = [];
		var _g = 0;
		while(_g < size) {
			_g++;
			table.push(haxe_zip_Huffman.Found(-1));
		}
		this.treeWalk(table,0,0,d,t);
		return haxe_zip_Huffman.NeedBits(d,table);
	}
	,treeWalk: function(table,p,cd,d,t) {
		switch(t[1]) {
		case 1:
			if(d > 0) {
				this.treeWalk(table,p,cd + 1,d - 1,t[2]);
				this.treeWalk(table,p | 1 << cd,cd + 1,d - 1,t[3]);
			} else table[p] = this.treeCompress(t);
			break;
		default:
			table[p] = this.treeCompress(t);
		}
	}
	,treeMake: function(bits,maxbits,v,len) {
		if(len > maxbits) throw new js__$Boot_HaxeError("Invalid huffman");
		var idx = v << 5 | len;
		if(bits.h.hasOwnProperty(idx)) return haxe_zip_Huffman.Found(bits.h[idx]);
		v <<= 1;
		len += 1;
		return haxe_zip_Huffman.NeedBit(this.treeMake(bits,maxbits,v,len),this.treeMake(bits,maxbits,v | 1,len));
	}
	,make: function(lengths,pos,nlengths,maxbits) {
		var counts = [];
		var tmp = [];
		if(maxbits > 32) throw new js__$Boot_HaxeError("Invalid huffman");
		var _g = 0;
		while(_g < maxbits) {
			_g++;
			counts.push(0);
			tmp.push(0);
		}
		var _g1 = 0;
		while(_g1 < nlengths) {
			var i = _g1++;
			var p = lengths[i + pos];
			if(p >= maxbits) throw new js__$Boot_HaxeError("Invalid huffman");
			counts[p]++;
		}
		var code = 0;
		var _g11 = 1;
		var _g2 = maxbits - 1;
		while(_g11 < _g2) {
			var i1 = _g11++;
			code = code + counts[i1] << 1;
			tmp[i1] = code;
		}
		var bits = new haxe_ds_IntMap();
		var _g3 = 0;
		while(_g3 < nlengths) {
			var i2 = _g3++;
			var l = lengths[i2 + pos];
			if(l != 0) {
				var n = tmp[l - 1];
				tmp[l - 1] = n + 1;
				bits.h[n << 5 | l] = i2;
			}
		}
		return this.treeCompress(haxe_zip_Huffman.NeedBit(this.treeMake(bits,maxbits,0,1),this.treeMake(bits,maxbits,1,1)));
	}
	,__class__: haxe_zip_HuffTools
};
var haxe_zip__$InflateImpl_Window = function(hasCrc) {
	this.buffer = haxe_io_Bytes.alloc(65536);
	this.pos = 0;
	if(hasCrc) this.crc = new haxe_crypto_Adler32();
};
haxe_zip__$InflateImpl_Window.__name__ = ["haxe","zip","_InflateImpl","Window"];
haxe_zip__$InflateImpl_Window.prototype = {
	slide: function() {
		if(this.crc != null) this.crc.update(this.buffer,0,32768);
		var b = haxe_io_Bytes.alloc(65536);
		this.pos -= 32768;
		b.blit(0,this.buffer,32768,this.pos);
		this.buffer = b;
	}
	,addBytes: function(b,p,len) {
		if(this.pos + len > 65536) this.slide();
		this.buffer.blit(this.pos,b,p,len);
		this.pos += len;
	}
	,addByte: function(c) {
		if(this.pos == 65536) this.slide();
		this.buffer.b[this.pos] = c & 255;
		this.pos++;
	}
	,getLastChar: function() {
		return this.buffer.b[this.pos - 1];
	}
	,available: function() {
		return this.pos;
	}
	,checksum: function() {
		if(this.crc != null) this.crc.update(this.buffer,0,this.pos);
		return this.crc;
	}
	,__class__: haxe_zip__$InflateImpl_Window
};
var haxe_zip__$InflateImpl_State = { __ename__ : true, __constructs__ : ["Head","Block","CData","Flat","Crc","Dist","DistOne","Done"] };
haxe_zip__$InflateImpl_State.Head = ["Head",0];
haxe_zip__$InflateImpl_State.Head.toString = $estr;
haxe_zip__$InflateImpl_State.Head.__enum__ = haxe_zip__$InflateImpl_State;
haxe_zip__$InflateImpl_State.Block = ["Block",1];
haxe_zip__$InflateImpl_State.Block.toString = $estr;
haxe_zip__$InflateImpl_State.Block.__enum__ = haxe_zip__$InflateImpl_State;
haxe_zip__$InflateImpl_State.CData = ["CData",2];
haxe_zip__$InflateImpl_State.CData.toString = $estr;
haxe_zip__$InflateImpl_State.CData.__enum__ = haxe_zip__$InflateImpl_State;
haxe_zip__$InflateImpl_State.Flat = ["Flat",3];
haxe_zip__$InflateImpl_State.Flat.toString = $estr;
haxe_zip__$InflateImpl_State.Flat.__enum__ = haxe_zip__$InflateImpl_State;
haxe_zip__$InflateImpl_State.Crc = ["Crc",4];
haxe_zip__$InflateImpl_State.Crc.toString = $estr;
haxe_zip__$InflateImpl_State.Crc.__enum__ = haxe_zip__$InflateImpl_State;
haxe_zip__$InflateImpl_State.Dist = ["Dist",5];
haxe_zip__$InflateImpl_State.Dist.toString = $estr;
haxe_zip__$InflateImpl_State.Dist.__enum__ = haxe_zip__$InflateImpl_State;
haxe_zip__$InflateImpl_State.DistOne = ["DistOne",6];
haxe_zip__$InflateImpl_State.DistOne.toString = $estr;
haxe_zip__$InflateImpl_State.DistOne.__enum__ = haxe_zip__$InflateImpl_State;
haxe_zip__$InflateImpl_State.Done = ["Done",7];
haxe_zip__$InflateImpl_State.Done.toString = $estr;
haxe_zip__$InflateImpl_State.Done.__enum__ = haxe_zip__$InflateImpl_State;
var haxe_zip_InflateImpl = function(i,header,crc) {
	if(crc == null) crc = true;
	if(header == null) header = true;
	this["final"] = false;
	this.htools = new haxe_zip_HuffTools();
	this.huffman = this.buildFixedHuffman();
	this.huffdist = null;
	this.len = 0;
	this.dist = 0;
	this.state = header?haxe_zip__$InflateImpl_State.Head:haxe_zip__$InflateImpl_State.Block;
	this.input = i;
	this.bits = 0;
	this.nbits = 0;
	this.needed = 0;
	this.output = null;
	this.outpos = 0;
	this.lengths = [];
	var _g = 0;
	while(_g < 19) {
		_g++;
		this.lengths.push(-1);
	}
	this.window = new haxe_zip__$InflateImpl_Window(crc);
};
haxe_zip_InflateImpl.__name__ = ["haxe","zip","InflateImpl"];
haxe_zip_InflateImpl.run = function(i,bufsize) {
	if(bufsize == null) bufsize = 65536;
	var buf = haxe_io_Bytes.alloc(bufsize);
	var output = new haxe_io_BytesBuffer();
	var inflate = new haxe_zip_InflateImpl(i);
	while(true) {
		var len = inflate.readBytes(buf,0,bufsize);
		if(len < 0 || len > buf.length) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
		var b2 = buf.b;
		var _g1 = 0;
		while(_g1 < len) {
			var i1 = _g1++;
			output.b.push(b2[i1]);
		}
		if(len < bufsize) break;
	}
	return output.getBytes();
};
haxe_zip_InflateImpl.prototype = {
	buildFixedHuffman: function() {
		if(haxe_zip_InflateImpl.FIXED_HUFFMAN != null) return haxe_zip_InflateImpl.FIXED_HUFFMAN;
		var a = [];
		var _g = 0;
		while(_g < 288) {
			var n = _g++;
			a.push(n <= 143?8:n <= 255?9:n <= 279?7:8);
		}
		haxe_zip_InflateImpl.FIXED_HUFFMAN = this.htools.make(a,0,288,10);
		return haxe_zip_InflateImpl.FIXED_HUFFMAN;
	}
	,readBytes: function(b,pos,len) {
		this.needed = len;
		this.outpos = pos;
		this.output = b;
		if(len > 0) while(this.inflateLoop()) {
		}
		return len - this.needed;
	}
	,getBits: function(n) {
		while(this.nbits < n) {
			this.bits |= this.input.readByte() << this.nbits;
			this.nbits += 8;
		}
		var b = this.bits & (1 << n) - 1;
		this.nbits -= n;
		this.bits >>= n;
		return b;
	}
	,getBit: function() {
		if(this.nbits == 0) {
			this.nbits = 8;
			this.bits = this.input.readByte();
		}
		var b = (this.bits & 1) == 1;
		this.nbits--;
		this.bits >>= 1;
		return b;
	}
	,getRevBits: function(n) {
		return n == 0?0:this.getBit()?1 << n - 1 | this.getRevBits(n - 1):this.getRevBits(n - 1);
	}
	,resetBits: function() {
		this.bits = 0;
		this.nbits = 0;
	}
	,addBytes: function(b,p,len) {
		this.window.addBytes(b,p,len);
		this.output.blit(this.outpos,b,p,len);
		this.needed -= len;
		this.outpos += len;
	}
	,addByte: function(b) {
		this.window.addByte(b);
		this.output.b[this.outpos] = b & 255;
		this.needed--;
		this.outpos++;
	}
	,addDistOne: function(n) {
		var c = this.window.getLastChar();
		var _g = 0;
		while(_g < n) {
			_g++;
			this.addByte(c);
		}
	}
	,addDist: function(d,len) {
		this.addBytes(this.window.buffer,this.window.pos - d,len);
	}
	,applyHuffman: function(h) {
		var tmp;
		switch(h[1]) {
		case 0:
			tmp = h[2];
			break;
		case 1:
			tmp = this.applyHuffman(this.getBit()?h[3]:h[2]);
			break;
		case 2:
			tmp = this.applyHuffman(h[3][this.getBits(h[2])]);
			break;
		}
		return tmp;
	}
	,inflateLengths: function(a,max) {
		var i = 0;
		var prev = 0;
		while(i < max) {
			var n = this.applyHuffman(this.huffman);
			switch(n) {
			case 0:case 1:case 2:case 3:case 4:case 5:case 6:case 7:case 8:case 9:case 10:case 11:case 12:case 13:case 14:case 15:
				prev = n;
				a[i] = n;
				i++;
				break;
			case 16:
				var end = i + 3 + this.getBits(2);
				if(end > max) throw new js__$Boot_HaxeError("Invalid data");
				while(i < end) {
					a[i] = prev;
					i++;
				}
				break;
			case 17:
				i += 3 + this.getBits(3);
				if(i > max) throw new js__$Boot_HaxeError("Invalid data");
				break;
			case 18:
				i += 11 + this.getBits(7);
				if(i > max) throw new js__$Boot_HaxeError("Invalid data");
				break;
			default:
				throw new js__$Boot_HaxeError("Invalid data");
			}
		}
	}
	,inflateLoop: function() {
		var _g = this.state;
		switch(_g[1]) {
		case 0:
			var cmf = this.input.readByte();
			var cm = cmf & 15;
			if(cm != 8) throw new js__$Boot_HaxeError("Invalid data");
			var flg = this.input.readByte();
			var fdict = (flg & 32) != 0;
			if(((cmf << 8) + flg) % 31 != 0) throw new js__$Boot_HaxeError("Invalid data");
			if(fdict) throw new js__$Boot_HaxeError("Unsupported dictionary");
			this.state = haxe_zip__$InflateImpl_State.Block;
			return true;
		case 4:
			var calc = this.window.checksum();
			if(calc == null) {
				this.state = haxe_zip__$InflateImpl_State.Done;
				return true;
			}
			var crc = haxe_crypto_Adler32.read(this.input);
			if(!calc.equals(crc)) throw new js__$Boot_HaxeError("Invalid CRC");
			this.state = haxe_zip__$InflateImpl_State.Done;
			return true;
		case 7:
			return false;
		case 1:
			this["final"] = this.getBit();
			var _g1 = this.getBits(2);
			switch(_g1) {
			case 0:
				this.len = this.input.readUInt16();
				var nlen = this.input.readUInt16();
				if(nlen != 65535 - this.len) throw new js__$Boot_HaxeError("Invalid data");
				this.state = haxe_zip__$InflateImpl_State.Flat;
				var r = this.inflateLoop();
				this.resetBits();
				return r;
			case 1:
				this.huffman = this.buildFixedHuffman();
				this.huffdist = null;
				this.state = haxe_zip__$InflateImpl_State.CData;
				return true;
			case 2:
				var hlit = this.getBits(5) + 257;
				var hdist = this.getBits(5) + 1;
				var hclen = this.getBits(4) + 4;
				var _g2 = 0;
				while(_g2 < hclen) {
					var i = _g2++;
					this.lengths[haxe_zip_InflateImpl.CODE_LENGTHS_POS[i]] = this.getBits(3);
				}
				var _g21 = hclen;
				while(_g21 < 19) {
					var i1 = _g21++;
					this.lengths[haxe_zip_InflateImpl.CODE_LENGTHS_POS[i1]] = 0;
				}
				this.huffman = this.htools.make(this.lengths,0,19,8);
				var lengths = [];
				var _g3 = 0;
				var _g22 = hlit + hdist;
				while(_g3 < _g22) {
					_g3++;
					lengths.push(0);
				}
				this.inflateLengths(lengths,hlit + hdist);
				this.huffdist = this.htools.make(lengths,hlit,hdist,16);
				this.huffman = this.htools.make(lengths,0,hlit,16);
				this.state = haxe_zip__$InflateImpl_State.CData;
				return true;
			default:
				throw new js__$Boot_HaxeError("Invalid data");
			}
			break;
		case 3:
			var rlen = this.len < this.needed?this.len:this.needed;
			var bytes = this.input.read(rlen);
			this.len -= rlen;
			this.addBytes(bytes,0,rlen);
			if(this.len == 0) this.state = this["final"]?haxe_zip__$InflateImpl_State.Crc:haxe_zip__$InflateImpl_State.Block;
			return this.needed > 0;
		case 6:
			var rlen1 = this.len < this.needed?this.len:this.needed;
			this.addDistOne(rlen1);
			this.len -= rlen1;
			if(this.len == 0) this.state = haxe_zip__$InflateImpl_State.CData;
			return this.needed > 0;
		case 5:
			while(this.len > 0 && this.needed > 0) {
				var rdist = this.len < this.dist?this.len:this.dist;
				var rlen2 = this.needed < rdist?this.needed:rdist;
				this.addDist(this.dist,rlen2);
				this.len -= rlen2;
			}
			if(this.len == 0) this.state = haxe_zip__$InflateImpl_State.CData;
			return this.needed > 0;
		case 2:
			var n = this.applyHuffman(this.huffman);
			if(n < 256) {
				this.addByte(n);
				return this.needed > 0;
			} else if(n == 256) {
				this.state = this["final"]?haxe_zip__$InflateImpl_State.Crc:haxe_zip__$InflateImpl_State.Block;
				return true;
			} else {
				n -= 257;
				var extra_bits = haxe_zip_InflateImpl.LEN_EXTRA_BITS_TBL[n];
				if(extra_bits == -1) throw new js__$Boot_HaxeError("Invalid data");
				this.len = haxe_zip_InflateImpl.LEN_BASE_VAL_TBL[n] + this.getBits(extra_bits);
				var dist_code = this.huffdist == null?this.getRevBits(5):this.applyHuffman(this.huffdist);
				extra_bits = haxe_zip_InflateImpl.DIST_EXTRA_BITS_TBL[dist_code];
				if(extra_bits == -1) throw new js__$Boot_HaxeError("Invalid data");
				this.dist = haxe_zip_InflateImpl.DIST_BASE_VAL_TBL[dist_code] + this.getBits(extra_bits);
				if(this.dist > this.window.available()) throw new js__$Boot_HaxeError("Invalid data");
				this.state = this.dist == 1?haxe_zip__$InflateImpl_State.DistOne:haxe_zip__$InflateImpl_State.Dist;
				return true;
			}
			break;
		}
	}
	,__class__: haxe_zip_InflateImpl
};
var haxe_zip_Uncompress = function() { };
haxe_zip_Uncompress.__name__ = ["haxe","zip","Uncompress"];
haxe_zip_Uncompress.run = function(src,bufsize) {
	return haxe_zip_InflateImpl.run(new haxe_io_BytesInput(src),bufsize);
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__name__ = ["js","_Boot","HaxeError"];
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = ["js","Boot"];
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__cast = function(o,t) {
	if(js_Boot.__instanceof(o,t)) return o; else throw new js__$Boot_HaxeError("Cannot cast " + Std.string(o) + " to " + Std.string(t));
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return (Function("return typeof " + name + " != \"undefined\" ? " + name + " : null"))();
};
var js_Browser = function() { };
js_Browser.__name__ = ["js","Browser"];
js_Browser.alert = function(v) {
	window.alert(js_Boot.__string_rec(v,""));
};
var js_html__$CanvasElement_CanvasUtil = function() { };
js_html__$CanvasElement_CanvasUtil.__name__ = ["js","html","_CanvasElement","CanvasUtil"];
js_html__$CanvasElement_CanvasUtil.getContextWebGL = function(canvas,attribs) {
	var _g = 0;
	var _g1 = ["webgl","experimental-webgl"];
	while(_g < _g1.length) {
		var name = _g1[_g];
		++_g;
		var ctx = canvas.getContext(name,attribs);
		if(ctx != null) return ctx;
	}
	return null;
};
var js_html_compat_ArrayBuffer = function(a) {
	if((a instanceof Array) && a.__enum__ == null) {
		this.a = a;
		this.byteLength = a.length;
	} else {
		var len = a;
		this.a = [];
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			this.a[i] = 0;
		}
		this.byteLength = len;
	}
};
js_html_compat_ArrayBuffer.__name__ = ["js","html","compat","ArrayBuffer"];
js_html_compat_ArrayBuffer.sliceImpl = function(begin,end) {
	var u = new Uint8Array(this,begin,end == null?null:end - begin);
	var result = new ArrayBuffer(u.byteLength);
	var resultArray = new Uint8Array(result);
	resultArray.set(u);
	return result;
};
js_html_compat_ArrayBuffer.prototype = {
	slice: function(begin,end) {
		return new js_html_compat_ArrayBuffer(this.a.slice(begin,end));
	}
	,__class__: js_html_compat_ArrayBuffer
};
var js_html_compat_DataView = function(buffer,byteOffset,byteLength) {
	this.buf = buffer;
	this.offset = byteOffset == null?0:byteOffset;
	this.length = byteLength == null?buffer.byteLength - this.offset:byteLength;
	if(this.offset < 0 || this.length < 0 || this.offset + this.length > buffer.byteLength) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
};
js_html_compat_DataView.__name__ = ["js","html","compat","DataView"];
js_html_compat_DataView.prototype = {
	getInt8: function(byteOffset) {
		var v = this.buf.a[this.offset + byteOffset];
		return v >= 128?v - 256:v;
	}
	,getUint8: function(byteOffset) {
		return this.buf.a[this.offset + byteOffset];
	}
	,getInt16: function(byteOffset,littleEndian) {
		var v = this.getUint16(byteOffset,littleEndian);
		return v >= 32768?v - 65536:v;
	}
	,getUint16: function(byteOffset,littleEndian) {
		return littleEndian?this.buf.a[this.offset + byteOffset] | this.buf.a[this.offset + byteOffset + 1] << 8:this.buf.a[this.offset + byteOffset] << 8 | this.buf.a[this.offset + byteOffset + 1];
	}
	,getInt32: function(byteOffset,littleEndian) {
		var p = this.offset + byteOffset;
		var a = this.buf.a[p++];
		var b = this.buf.a[p++];
		var c = this.buf.a[p++];
		var d = this.buf.a[p++];
		return littleEndian?a | b << 8 | c << 16 | d << 24:d | c << 8 | b << 16 | a << 24;
	}
	,getUint32: function(byteOffset,littleEndian) {
		var v = this.getInt32(byteOffset,littleEndian);
		return v < 0?v + 4294967296.:v;
	}
	,getFloat32: function(byteOffset,littleEndian) {
		return haxe_io_FPHelper.i32ToFloat(this.getInt32(byteOffset,littleEndian));
	}
	,getFloat64: function(byteOffset,littleEndian) {
		var a = this.getInt32(byteOffset,littleEndian);
		var b = this.getInt32(byteOffset + 4,littleEndian);
		return haxe_io_FPHelper.i64ToDouble(littleEndian?a:b,littleEndian?b:a);
	}
	,setInt8: function(byteOffset,value) {
		this.buf.a[byteOffset + this.offset] = value < 0?value + 128 & 255:value & 255;
	}
	,setUint8: function(byteOffset,value) {
		this.buf.a[byteOffset + this.offset] = value & 255;
	}
	,setInt16: function(byteOffset,value,littleEndian) {
		this.setUint16(byteOffset,value < 0?value + 65536:value,littleEndian);
	}
	,setUint16: function(byteOffset,value,littleEndian) {
		var p = byteOffset + this.offset;
		if(littleEndian) {
			this.buf.a[p] = value & 255;
			this.buf.a[p++] = value >> 8 & 255;
		} else {
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p] = value & 255;
		}
	}
	,setInt32: function(byteOffset,value,littleEndian) {
		this.setUint32(byteOffset,value,littleEndian);
	}
	,setUint32: function(byteOffset,value,littleEndian) {
		var p = byteOffset + this.offset;
		if(littleEndian) {
			this.buf.a[p++] = value & 255;
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p++] = value >> 16 & 255;
			this.buf.a[p++] = value >>> 24;
		} else {
			this.buf.a[p++] = value >>> 24;
			this.buf.a[p++] = value >> 16 & 255;
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p++] = value & 255;
		}
	}
	,setFloat32: function(byteOffset,value,littleEndian) {
		this.setUint32(byteOffset,haxe_io_FPHelper.floatToI32(value),littleEndian);
	}
	,setFloat64: function(byteOffset,value,littleEndian) {
		var i64 = haxe_io_FPHelper.doubleToI64(value);
		if(littleEndian) {
			this.setUint32(byteOffset,i64.low);
			this.setUint32(byteOffset,i64.high);
		} else {
			this.setUint32(byteOffset,i64.high);
			this.setUint32(byteOffset,i64.low);
		}
	}
	,__class__: js_html_compat_DataView
};
var js_html_compat_Uint8Array = function() { };
js_html_compat_Uint8Array.__name__ = ["js","html","compat","Uint8Array"];
js_html_compat_Uint8Array._new = function(arg1,offset,length) {
	var arr;
	if(typeof(arg1) == "number") {
		arr = [];
		var _g = 0;
		while(_g < arg1) {
			var i = _g++;
			arr[i] = 0;
		}
		arr.byteLength = arr.length;
		arr.byteOffset = 0;
		arr.buffer = new js_html_compat_ArrayBuffer(arr);
	} else if(js_Boot.__instanceof(arg1,js_html_compat_ArrayBuffer)) {
		var buffer = arg1;
		if(offset == null) offset = 0;
		if(length == null) length = buffer.byteLength - offset;
		if(offset == 0) arr = buffer.a; else arr = buffer.a.slice(offset,offset + length);
		arr.byteLength = arr.length;
		arr.byteOffset = offset;
		arr.buffer = buffer;
	} else if((arg1 instanceof Array) && arg1.__enum__ == null) {
		arr = arg1.slice();
		arr.byteLength = arr.length;
		arr.byteOffset = 0;
		arr.buffer = new js_html_compat_ArrayBuffer(arr);
	} else throw new js__$Boot_HaxeError("TODO " + Std.string(arg1));
	arr.subarray = js_html_compat_Uint8Array._subarray;
	arr.set = js_html_compat_Uint8Array._set;
	return arr;
};
js_html_compat_Uint8Array._set = function(arg,offset) {
	var t = this;
	if(js_Boot.__instanceof(arg.buffer,js_html_compat_ArrayBuffer)) {
		var a = arg;
		if(arg.byteLength + offset > t.byteLength) throw new js__$Boot_HaxeError("set() outside of range");
		var _g1 = 0;
		var _g = arg.byteLength;
		while(_g1 < _g) {
			var i = _g1++;
			t[i + offset] = a[i];
		}
	} else if((arg instanceof Array) && arg.__enum__ == null) {
		var a1 = arg;
		if(a1.length + offset > t.byteLength) throw new js__$Boot_HaxeError("set() outside of range");
		var _g11 = 0;
		var _g2 = a1.length;
		while(_g11 < _g2) {
			var i1 = _g11++;
			t[i1 + offset] = a1[i1];
		}
	} else throw new js__$Boot_HaxeError("TODO");
};
js_html_compat_Uint8Array._subarray = function(start,end) {
	var t = this;
	var a = js_html_compat_Uint8Array._new(t.slice(start,end));
	a.byteOffset = start;
	return a;
};
var util_CharacterController = function(input,body) {
	this.jumping = false;
	this.jumpUnit = new glaze_geom_Vector2();
	this.controlForce = new glaze_geom_Vector2();
	this.input = input;
	this.body = body;
};
util_CharacterController.__name__ = ["util","CharacterController"];
util_CharacterController.prototype = {
	update: function() {
		var _this = this.controlForce;
		_this.x = .0;
		_this.y = .0;
		var tmp;
		var _this1 = this.input;
		var duration = _this1.keyMap[65];
		if(duration > 0) tmp = _this1.frameRef - duration; else tmp = -1;
		var left = tmp;
		var tmp1;
		var _this2 = this.input;
		var duration1 = _this2.keyMap[68];
		if(duration1 > 0) tmp1 = _this2.frameRef - duration1; else tmp1 = -1;
		var right = tmp1;
		var tmp2;
		var _this3 = this.input;
		tmp2 = _this3.keyMap[87] == _this3.frameRef - 1;
		var up = tmp2;
		var tmp3;
		var _this4 = this.input;
		var duration2 = _this4.keyMap[87];
		if(duration2 > 0) tmp3 = _this4.frameRef - duration2; else tmp3 = -1;
		var upDuration = tmp3;
		var _this5 = this.input;
		var duration3 = _this5.keyMap[83];
		if(duration3 > 0) _this5.frameRef - duration3; else -1;
		if(!this.jumping && this.body.onGround && up) {
			this.jumping = true;
			this.controlForce.y -= 200.;
		}
		if(this.jumping && this.input.keyMap[87] == 0 || this.body.lastNormal.y > 0) this.jumping = false;
		this.body.onGround && !this.body.onGroundPrev;
		if(this.body.onGround) {
			if(left > 0) this.controlForce.x -= 20;
			if(right > 0) this.controlForce.x += 20;
			if(up) this.controlForce.y -= 200.;
		} else {
			if(left > 0) this.controlForce.x -= 10;
			if(right > 0) this.controlForce.x += 10;
			if(this.jumping && upDuration > 1 && upDuration < 10) this.controlForce.y -= 80.;
		}
		this.body.addForce(this.controlForce);
	}
	,__class__: util_CharacterController
};
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
String.prototype.__class__ = String;
String.__name__ = ["String"];
Array.__name__ = ["Array"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
var __map_reserved = {}
var ArrayBuffer = (Function("return typeof ArrayBuffer != 'undefined' ? ArrayBuffer : null"))() || js_html_compat_ArrayBuffer;
if(ArrayBuffer.prototype.slice == null) ArrayBuffer.prototype.slice = js_html_compat_ArrayBuffer.sliceImpl;
var DataView = (Function("return typeof DataView != 'undefined' ? DataView : null"))() || js_html_compat_DataView;
var Uint8Array = (Function("return typeof Uint8Array != 'undefined' ? Uint8Array : null"))() || js_html_compat_Uint8Array._new;
GameTestA.MAP_DATA = "data/testMap.tmx";
GameTestA.TEXTURE_CONFIG = "data/sprites.json";
GameTestA.TEXTURE_DATA = "data/sprites.png";
GameTestA.TILE_SPRITE_SHEET = "data/spelunky-tiles.png";
GameTestA.TILE_MAP_DATA_1 = "data/spelunky0.png";
GameTestA.TILE_MAP_DATA_2 = "data/spelunky1.png";
Xml.Element = 0;
Xml.PCData = 1;
Xml.CData = 2;
Xml.Comment = 3;
Xml.DocType = 4;
Xml.ProcessingInstruction = 5;
Xml.Document = 6;
glaze_core_GameLoop.MIN_DELTA = 16.6666666766666687;
glaze_eco_core_Phase.DEFAULT_TIME_DELTA = 16.6666666666666679;
glaze_engine_components_Display.NAME = "Display";
glaze_engine_components_ParticleEmitters.NAME = "ParticleEmitters";
glaze_engine_components_Physics.NAME = "Physics";
glaze_engine_components_Position.NAME = "Position";
glaze_engine_components_Script.NAME = "Script";
glaze_geom_Vector2.ZERO_TOLERANCE = 1e-08;
glaze_particle_BlockSpriteParticle.INV_ALPHA = 0.00392156862745098;
glaze_physics_collision_Intersect.epsilon = 1e-8;
glaze_physics_collision_Map.COLLIDABLE = 1;
glaze_physics_collision_Map.ONE_WAY = 2;
glaze_physics_collision_Map.CORRECTION = .0;
glaze_physics_collision_Map.ROUNDDOWN = .01;
glaze_physics_collision_Map.ROUNDUP = .5;
glaze_physics_components_PhysicsBody.NAME = "PhysicsBody";
glaze_physics_components_PhysicsCollision.NAME = "PhysicsCollision";
glaze_render_renderers_webgl_PointSpriteLightMapRenderer.SPRITE_VERTEX_SHADER = ["precision mediump float;","uniform vec2 projectionVector;","attribute vec2 position;","attribute float size;","attribute vec4 colour;","varying vec4 vColor;","void main() {","gl_PointSize = size;","vColor = colour;","gl_Position = vec4( position.x / projectionVector.x -1.0, position.y / -projectionVector.y + 1.0 , 0.0, 1.0);","}"];
glaze_render_renderers_webgl_PointSpriteLightMapRenderer.SPRITE_FRAGMENT_SHADER = ["precision mediump float;","varying vec4 vColor;","void main() {","gl_FragColor = vColor;","}"];
glaze_render_renderers_webgl_SpriteRenderer.SPRITE_VERTEX_SHADER = ["precision mediump float;","attribute vec2 aVertexPosition;","attribute vec2 aTextureCoord;","attribute float aColor;","uniform vec2 projectionVector;","varying vec2 vTextureCoord;","varying float vColor;","void main(void) {","gl_Position = vec4( aVertexPosition.x / projectionVector.x -1.0, aVertexPosition.y / -projectionVector.y + 1.0 , 0.0, 1.0);","vTextureCoord = aTextureCoord;","vColor = aColor;","}"];
glaze_render_renderers_webgl_SpriteRenderer.SPRITE_FRAGMENT_SHADER = ["precision mediump float;","varying vec2 vTextureCoord;","varying float vColor;","uniform sampler2D uSampler;","void main(void) {","gl_FragColor = texture2D(uSampler,vTextureCoord) * vColor;","}"];
glaze_render_renderers_webgl_TileMap.TILEMAP_VERTEX_SHADER = ["precision mediump float;","attribute vec2 position;","attribute vec2 texture;","varying vec2 pixelCoord;","varying vec2 texCoord;","uniform vec2 viewOffset;","uniform vec2 viewportSize;","uniform vec2 inverseTileTextureSize;","uniform float inverseTileSize;","void main(void) {","   pixelCoord = (texture * viewportSize) + viewOffset;","   texCoord = pixelCoord * inverseTileTextureSize * inverseTileSize;","   gl_Position = vec4(position, 0.0, 1.0);","}"];
glaze_render_renderers_webgl_TileMap.TILEMAP_FRAGMENT_SHADER = ["precision mediump float;","varying vec2 pixelCoord;","varying vec2 texCoord;","uniform sampler2D tiles;","uniform sampler2D sprites;","uniform vec2 inverseTileTextureSize;","uniform vec2 inverseSpriteTextureSize;","uniform float tileSize;","void main(void) {","   vec4 tile = texture2D(tiles, texCoord);","   if(tile.x == 1.0 && tile.y == 1.0) { discard; }","   vec2 spriteOffset = floor(tile.xy * 256.0) * tileSize;","   vec2 spriteCoord = mod(pixelCoord, tileSize);","   gl_FragColor = texture2D(sprites, (spriteOffset + spriteCoord) * inverseSpriteTextureSize);","}"];
glaze_tmx_TmxLayer.BASE64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
glaze_util_Random.PseudoRandomSeed = 3489752;
haxe_crypto_Base64.CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
haxe_crypto_Base64.BYTES = haxe_io_Bytes.ofString(haxe_crypto_Base64.CHARS);
haxe_io_FPHelper.i64tmp = (function($this) {
	var $r;
	var x = new haxe__$Int64__$_$_$Int64(0,0);
	$r = x;
	return $r;
}(this));
haxe_xml_Parser.escapes = (function($this) {
	var $r;
	var h = new haxe_ds_StringMap();
	if(__map_reserved.lt != null) h.setReserved("lt","<"); else h.h["lt"] = "<";
	if(__map_reserved.gt != null) h.setReserved("gt",">"); else h.h["gt"] = ">";
	if(__map_reserved.amp != null) h.setReserved("amp","&"); else h.h["amp"] = "&";
	if(__map_reserved.quot != null) h.setReserved("quot","\""); else h.h["quot"] = "\"";
	if(__map_reserved.apos != null) h.setReserved("apos","'"); else h.h["apos"] = "'";
	$r = h;
	return $r;
}(this));
haxe_zip_InflateImpl.LEN_EXTRA_BITS_TBL = [0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,-1,-1];
haxe_zip_InflateImpl.LEN_BASE_VAL_TBL = [3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258];
haxe_zip_InflateImpl.DIST_EXTRA_BITS_TBL = [0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,-1,-1];
haxe_zip_InflateImpl.DIST_BASE_VAL_TBL = [1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577];
haxe_zip_InflateImpl.CODE_LENGTHS_POS = [16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15];
js_Boot.__toStr = {}.toString;
js_html_compat_Uint8Array.BYTES_PER_ELEMENT = 1;
util_CharacterController.WALK_FORCE = 20;
util_CharacterController.AIR_CONTROL_FORCE = 10;
util_CharacterController.JUMP_FORCE = 1000;
util_CharacterController.MAX_AIR_HORIZONTAL_VELOCITY = 500;
GameTestA.main();
})(typeof console != "undefined" ? console : {log:function(){}});
