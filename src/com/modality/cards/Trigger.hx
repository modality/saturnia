package com.modality.cards;

class Trigger extends Rule {
  public var effect:Message;

  public var interrupt:Bool;
  public var expire:Bool;

  public function new(_message:Message, _effect:Message)
  {
    super(_message);
    effect = _effect;
    interrupt = Std.bool(effect.remove("interrupt"));
    expire = Std.bool(effect.remove("expire"));
  }
}
