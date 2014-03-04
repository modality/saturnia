package com.saturnia;

class PirateEncounter extends Encounter
{
  public function new(_space:Space)
  {
    super(_space);
    type = "pirate";
    graphic = Assets.getImage("space_raider");
  }

  public override function activate()
  {
    space.object = this;
  }

}
