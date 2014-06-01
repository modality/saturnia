package com.saturnia;

import com.modality.cards.Message;

class CombatEffect
{
  public var message:Message;

  public var effect_target:String;
  public var effect_resource:String;
  public var effect_mod:String;
  public var effect_value:String;

  public function new(_message:Message)
  {
    message = _message;
    effect_target = message.tokens[1];
    effect_resource = message.tokens[2];
    effect_mod = message.tokens[3];
    effect_value = message.tokens[4];
  }

  public function apply(self:Inventory, opponent:Inventory = null):Bool
  {
    if(effect_target == "self") {
      applyTo(self);
      return true;
    } else if(opponent != null) {
      applyTo(opponent);
      return true;
    }

    trace("Could not apply effect! "+message);
    return false;
  }

  public function applyTo(target:Inventory):Void
  {
    var modval = Std.parseInt(effect_value);

    if(modval == null || (modval == 0 && effect_value != "0")) {
      trace("Can't parse effect value: "+effect_value);
      modval = 1;
    }

    if(effect_mod == "lose") {
      modval = modval * -1;
    }


    switch(effect_resource) {
      case "fuel":    target.fuel += modval;
      case "shield": target.shields += modval;
      case "cargo":   target.cargo += modval;
      case "science": target.science += modval;
      default: trace("Can't parse effect resource: "+effect_resource);
    }
  }
}
