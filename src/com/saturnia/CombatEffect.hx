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

  public function apply(_player:PlayerResources, _space:Space = null):Void
  {
    var modval = Std.parseInt(effect_value);

    if(modval == null || (modval == 0 && effect_value != "0")) {
      trace("Can't parse effect value: "+effect_value);
      modval = 1;
    }

    if(effect_mod == "loss") {
      modval = modval * -1;
    }

    if(effect_target == "self") {
      switch(effect_resource) {
        case "fuel":    _player.fuel += modval;
        case "shields": _player.shields += modval;
        case "cargo":   _player.cargo += modval;
        case "science": _player.science += modval;
        default: trace("Can't parse effect resource: "+effect_resource);
      }
    } else {
      var enc = cast(_space.encounter, PirateEncounter);
      if(effect_resource == "shields") {
        enc.life += modval;
      } else {
        trace("Can't do effect resource on opponent: "+effect_resource);
      }
    }
  }

  public function parseRule(rule:String):Array<String>
  {
    var tokens = [];
    var typeRx = ~/^(\w+)\(/;
    var paramRx = ~/\((.+)\)/;
    var splitRx = ~/, ?/;

    typeRx.match(rule);
    tokens.push(typeRx.matched(1));

    paramRx.match(rule);
    tokens = tokens.concat(splitRx.split(paramRx.matched(1)));
    
    return tokens;
  }
}
