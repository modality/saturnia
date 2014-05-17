package com.saturnia;

class CombatEffect
{
  public var effect:String;

  public var effect_target:String;
  public var effect_resource:String;
  public var effect_mod:String;
  public var effect_value:String;

  public function new(_effect:String)
  {
    effect = _effect;

    var tokens = parseRule(effect);
    effect_target = tokens[1];
    effect_resource = tokens[2];
    effect_mod = tokens[3];
    effect_value = tokens[4];
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

    trace("Could not apply effect! "+effect);
    return false;
  }

  public function applyTo(target:Inventory):Void
  {
    var modval = Std.parseInt(effect_value);

    if(modval == null || (modval == 0 && effect_value != "0")) {
      trace("Can't parse effect value: "+effect_value);
      modval = 1;
    }

    if(effect_mod == "loss") {
      modval = modval * -1;
    }

    switch(effect_resource) {
      case "fuel":    target.fuel += modval;
      case "shields": target.shields += modval;
      case "cargo":   target.cargo += modval;
      case "science": target.science += modval;
      default: trace("Can't parse effect resource: "+effect_resource);
    }
  }

  public function parseRule(rule:String):Array<String>
  {
    var tokens = [];
    var typeRx = ~/^(\w+)\(/;
    var paramRx = ~/\((.+)\)/;
    var splitRx = ~/, ?/g;

    typeRx.match(rule);
    tokens.push(typeRx.matched(1));

    paramRx.match(rule);
    tokens = tokens.concat(splitRx.split(paramRx.matched(1)));

    return tokens;
  }
}
