package com.saturnia;

import openfl.events.Event;
import com.modality.cards.Message;

class EffectEvent extends Event
{
  public static var APPLY:String = "apply effect";

  public var effect:Message;

  public function new(type:String, _effect:Message)
  {
    super(type);
    effect = _effect;
  }
}

