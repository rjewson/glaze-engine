package glaze.physics.components;

import glaze.eco.core.IComponent;
import glaze.physics.Body;
import glaze.physics.Material;

class PhysicsBody implements IComponent {
    
    public var body:Body;
    public var setMassFromVolume:Bool;

}