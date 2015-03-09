package com.saturnia;

class EngineerEncounter extends FriendlyEncounter
{
  public var parts:Array<ShipPart>;
  public var repairedPlayer:Bool = false;

  public override function activate()
  {
    space.object = this;
  }

  public function boughtPart(shipPart:ShipPart)
  {
    parts.remove(shipPart);
  }
}
