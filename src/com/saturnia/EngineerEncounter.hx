package com.saturnia;

class EngineerEncounter extends FriendlyEncounter
{
  public var parts:Array<ShipPart>;

  public override function activate()
  {
    space.object = this;
  }

  public function boughtPart(shipPart:ShipPart)
  {
    parts.remove(shipPart);
  }
}
