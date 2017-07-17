package exile.entities.items;

class Factory<T> {
  // factory method
  public function create(params:T):Entity {
    return new Entity(null,[]);
  }
  
  private function new () {}  // private constructor
}