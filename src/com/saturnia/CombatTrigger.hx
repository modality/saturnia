package com.saturnia;

class CombatTrigger extends CombatEffect
{
  public var trigger:String;

  public var trigger_type:String; // play, effect, reaction
  public var trigger_target:String;
  public var trigger_resource:String;
  public var trigger_mod:String;
  public var trigger_interrupt:Bool;
  public var trigger_expire:Bool;

  public var trigger_action:String;
  public var trigger_reaction:String;

  public function new(_trigger:String, _effect:String)
  {
    super(_effect);
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
