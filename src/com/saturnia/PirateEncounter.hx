package com.saturnia;

class PirateEncounter extends Encounter
{
  public var life:Int;

  public function new(_space:Space)
  {
    super(_space);
    type = "pirate";
    graphic = Assets.getImage("space_raider");
    life = 3;
  }

  public override function activate()
  {
    space.object = this;
  }

}
