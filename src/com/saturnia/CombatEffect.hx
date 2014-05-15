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
  }

  public function apply():Void
  {
  }
}
