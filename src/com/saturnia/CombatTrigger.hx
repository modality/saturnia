package com.saturnia;

class CombatTrigger extends CombatEffect
{
  public var trigger:String;

  public var trigger_type:String; // play, effect, reaction
  public var trigger_target:String;
  public var trigger_resource:String;
  public var trigger_mod:String;
  public var trigger_value:String;
  public var trigger_interrupt:Bool;
  public var trigger_expire:Bool;

  public var trigger_action:String;

  public function new(_trigger:String, _effect:String)
  {
    super(_effect);
    trigger = _trigger;

    var tokens = parseRule(trigger);
    trigger_type = tokens[0];
    switch(trigger_type) {
      case "effect":
        trigger_target = tokens[1];
        trigger_resource = tokens[2];
        trigger_mod = tokens[3];
        trigger_value = tokens[4];
        trigger_interrupt = true;
        trigger_expire = true;
      case "play":
        trigger_target = tokens[1];
        trigger_action = tokens[2];
        trigger_interrupt = false;
        trigger_expire = false;
      default:
        trace("Unable to classify :: "+trigger_type);
    }
  }

  public function actionWillTrigger(action:String):Bool
  {
    return trigger_type == "play" && match(trigger_action, action);
  }

  public function effectWillTrigger(combatEffect:CombatEffect):Bool
  {
    return trigger_type == "effect" &&
           match(trigger_target, combatEffect.effect_target) &&
           match(trigger_resource, combatEffect.effect_resource) &&
           match(trigger_mod, combatEffect.effect_mod);
  }

  public function match(watch:String, trig:String):Bool
  {
    return watch == "*" || watch == trig;
  }
}
