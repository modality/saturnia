package com.saturnia;

class PirateEncounter extends Encounter
{
  public var stats:CombatStats;
  public var description:String;
  public var scienceReward:Int;
  public var fuelReward:Int;

  public function new(_space:Space)
  {
    super(_space);
    type = "pirate";
    graphic = Assets.getImage("space_raider");
    stats = new CombatStats();
    scienceReward = 0;
    fuelReward = 0;
  }

  public override function activate()
  {
    space.object = this;
  }

}
