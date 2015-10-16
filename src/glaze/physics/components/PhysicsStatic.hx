package glaze.physics.components;

import glaze.eco.core.IComponent;

class PhysicsStaticX implements IComponent {
   //Only used to ensure its matched to a particular system 
   public var isStatic:Bool;

   public function new(isStatic:Bool=true) {
   	this.isStatic = isStatic;    
   }
}