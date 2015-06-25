package glaze.engine.factories;

import glaze.eco.core.Engine;

interface IEntityFactory {
	var mapping(get, never):String;
	function createEntity(data:Dynamic,engine:Engine):Void;
}