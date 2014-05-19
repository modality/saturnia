package com.modality.cards;

import com.modality.Message;

class Rule {
  public var message:Message;
  // public var negation:Bool;

  public function new(_message:Message)
  {
    message = _message;
  }

  public function relevant(input:Message):Bool
  {
    return input.type == message.type;
  }

  public function match(input:Message):Bool
  {
    for(key in message.keys()) {
      if(!(input.exists(key) && input.get(key) == message.get(key))) {
        return false;
      }
    }
    return true;
  }
}
