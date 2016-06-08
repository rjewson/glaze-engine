package glaze.engine.core;

import glaze.eco.core.Entity;
import glaze.engine.components.Destroy;

typedef LifeCycleCallback = Entity->Void;

class EngineLifecycle {

	public static inline var INITALIZE:String 	= "initalize";
	public static inline var RUNNING:String 	= "running";
	public static inline var DESTROY:String 	= "destroy";
	public static inline var CLEANUP:String 	= "cleanup";

	public static var LIFECYCLE_SET = [
		INITALIZE => onInitalize,
		RUNNING   => onRunning,
		DESTROY   => onDestroy,
		CLEANUP   => onCleanup
	];

	public function new() {
		
	}

	public static function onInitalize(entity:Entity) {
		trace('INITALIZE ${entity.name}');
	}

	public static function onRunning(entity:Entity) {
		trace('RUNNING ${entity.name}');
	}

	public static function onDestroy(entity:Entity) {
		trace('DESTROY ${entity.name}');		
		entity.addComponent(new Destroy(1)); 
	}

	public static function onCleanup(entity:Entity) {
		trace('CLEANUP ${entity.name}');
	}	

	public static function CreateLifeCylce(_onInitalize:LifeCycleCallback=null,_onRunning:LifeCycleCallback=null,_onDestroy:LifeCycleCallback=null,_onCleanup:LifeCycleCallback=null) {
		return [
			INITALIZE => (_onInitalize!=null?_onInitalize:EngineLifecycle.onInitalize),
			RUNNING   => (_onRunning!=null?_onRunning:EngineLifecycle.onRunning),
			DESTROY   => (_onDestroy!=null?_onDestroy:EngineLifecycle.onDestroy),
			CLEANUP   => (_onCleanup!=null?_onCleanup:EngineLifecycle.onCleanup)
		];
	}

}