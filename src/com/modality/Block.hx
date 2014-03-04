package com.modality;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Block extends Base
{
  public var x_index:Int;
  public var y_index:Int;
  public var state_str:String;
  public var objects:Array<Base>;
  public var object(get, set):Base;

  public function new(?_x:Int = 0, ?_y:Int = 0)
  {
    super(_x, _y);
    layer = 2;
    type = "block";
    state_str = "empty";
    objects = [];
  }

  public function setIndex(_x_index:Int, _y_index:Int):Void
  {
    x_index = _x_index;
    y_index = _y_index;
  }

  public function manhattan(b:Block):Int
  {
    return Math.round(Math.abs(x_index - b.x_index)) + Math.round(Math.abs(y_index - b.y_index));
  }

  public function destroy():Void
  {
    changeState("empty");
  }

  public function changeState(_state_str:String):Void
  {
    state_str = _state_str;
  }

  public function get_object():Base
  {
    if(objects.length > 0) return objects[0];
    return null;
  }

  public function set_object(object:Base):Base
  {
    objects = [object];
    return object;
  }

  public function hasObject(_type:String, ?_name:String):Bool
  {
    for(base in objects) {
      if(_name != null) {
        if(base.type == _type && base.name == _name && !base.dead) return true;
      } else {
        if(base.type == _type && !base.dead) return true;
      }
    }
    return false;
  }

  public function getObject(_type:String, ?_name:String):Base
  {
    for(base in objects) {
      if(base.type == _type && !base.dead) {
        if(_name == null || base.name == _name) {
          return base;
        }
      }
    }
    return null;
  }

  public function getObjects(_type:String, ?_name:String):Array<Base>
  {
    var objs:Array<Base> = [];
    for(base in objects) {
      if(base.type == _type && !base.dead) {
        if(_name == null || base.name == _name) {
          objs.push(base);
        }
      }
    }
    return objs;
  }
}
