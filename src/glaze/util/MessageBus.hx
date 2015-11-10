package glaze.util;

import haxe.ds.StringMap;

class MessageBus {

	public var map:StringMap<Array<Dynamic->Void>>;

	public function new() {
		map = new haxe.ds.StringMap<Array<Dynamic->Void>>();
	}

	public function register(channelName:String,callback:Dynamic->Void) {
		if (!map.exists(channelName)) {
			map.set(channelName,new Array<Dynamic->Void>());
		}
		var channel = map.get(channelName);
		channel.push(callback);
	}

	public function registerAll(channelNames:Array<String>,callback:Dynamic->Void) {
		for (channelName in channelNames)
			register(channelName,callback);
	}

	public function unregister(channelName:String,callback:Dynamic->Void) {
		if (!map.exists(channelName))
			return;
		var channel = map.get(channelName);
		channel.remove(callback);		
	}

	public function unregisterAll(channelNames:Array<String>,callback:Dynamic->Void) {
		for (channelName in channelNames)
			unregister(channelName,callback);
	}	

	public function trigger(channelName:String,data:Dynamic) {
		var channel = map.get(channelName);
		if (channel!=null) {
			for (channelItem in channel)
				channelItem(data);
		}
	}

	public function triggerAll(channelNames:Array<String>,data:Dynamic) {
		for (channelName in channelNames)
			trigger(channelName,data);
	}

}