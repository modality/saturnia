package com.saturnia;

import com.modality.cards.Message;
import com.modality.cards.Receiver;

class CardGameReceiver implements Receiver {
  public var target:Space;
  public var noRule:Message;
  public var self:Inventory;

  public function new(_self:Inventory) { 
    noRule = Message.read("(noRule)");
    self = _self;
  }

  public function setTarget(space:Space):Void
  {
    target = space;
  }

  public function clearTarget():Void
  {
    target = null;
  }

  public function eval(message:Message):Message
  {
    switch(message.type()) {
      case "effect":
	var ce = new CombatEffect(message);

	if(target != null && target.encounter != null) {
	  if(ce.apply(self, target.encounter.inventory)) {
	    return message;
	  }
	} else if(ce.apply(self)) {
	  return message;
	}

	return noRule;
      case "explore":
	return message;
      case "exploreNavigator":
	return message;
      case "play":
	return message;
      default:
	return noRule;
    }
  }
}
