package com.modality.cards;

class Trigger {
  public var trigger:Message;
  public var response:Message;
  public var interrupt:Bool;
  public var expire:Bool;

  public function new(_t:Message, _r:Message, _i:Bool = false, _e:Bool = false)
  {
    trigger = _t;
    response = _r;
    interrupt = _i;
    expire = _e;
  }

  public function match(input:Message):Bool
  {
    for(i in 0...trigger.tokens.length) {
      if(trigger.tokens[i] != input.tokens[i]) {
        return false;
      }
    }
    return true;
  }
}
