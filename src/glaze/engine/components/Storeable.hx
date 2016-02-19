package glaze.engine.components;

import glaze.eco.core.IComponent;

class Storeable implements IComponent {
	
	public function new(type:String=null,value:Int=0):Void {
	    this.permanentType = type;
	    this.permanentValue = value;
	}

	public var permanentType:String;
	public var permanentValue:Int;

}