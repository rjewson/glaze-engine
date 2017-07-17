package glaze.engine.components;

import glaze.eco.core.Entity;
import glaze.eco.core.IComponent;
import glaze.signals.Signal1;
import glaze.ai.fsm.LightStateMachine;
import glaze.ai.fsm.LightStateMachine.LightStateSet;


class ECState implements IComponent {

  public var state:LightStateMachine;
  public var owner:Entity;
  public var order:Array<String>;

  public function new(states:LightStateSet,initalState:String,?order:Array<String>) {
    state = new LightStateMachine(states,initalState);
  }

}

// class ECState implements IComponent {

//     public var states:StateMap;
//     public var previousState:String;
//     public var currentState:String;
//     public var owner:Entity;
//     public var onChanged:Signal1<ECState>;

// 	public var triggerChannels:Array<String>;


//   public function new(states:StateMap, initialState:String, triggerChannels:Array<String> = null) {
//     this.states = states;
//     this.onChanged = new Signal1<ECState>();
//     this.triggerChannels = triggerChannels;
//   }

//   public function setState(name:String) {
//     var nextState = states.get(name);
    
//     if (nextState!=null) {
//       previousState=currentState;
//       currentState=name;
//       nextState(owner);
//       onChanged.dispatch(this);
//     }
//   }

//   public function addState(name:String, handler:StateHandler) {
//     states.set(name,handler);
//   }

// }