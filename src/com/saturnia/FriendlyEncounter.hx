package com.saturnia;

import openfl.events.Event;
import com.modality.AugRandom;

class FriendlyEncounter extends Encounter
{
  public var level:Int;

  public function new(_space:Space)
  {
    super(_space);
    type = "merchant";
    graphic = Assets.getImage("space_merchant");
  }

  public function cycle():Void
  {

  }
}
