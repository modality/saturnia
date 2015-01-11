package com.saturnia;

class PirateEncounter extends Encounter
{
  public var stats:CombatStats;

  public function new(_space:Space)
  {
    super(_space);
    type = "pirate";
    graphic = Assets.getImage("space_raider");
    stats = new CombatStats();
  }

  public override function activate()
  {
    space.object = this;
  }

}
