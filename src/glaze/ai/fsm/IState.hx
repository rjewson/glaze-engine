package glaze.ai.fsm;

import glaze.eco.core.Entity;

interface IState {
	function enter(entity:Entity):Void;
	function update(entity:Entity):Void;
	function exit(entity:Entity):Void;
	function message(entity:Entity,message:Dynamic):Void;	
}