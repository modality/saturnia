package com.saturnia.ui;

import openfl.events.Event;

class ShipPartEvent extends Event
{
  public var shipPart:ShipPart;

  public function new(type:String, _shipPart:ShipPart)
  {
    super(type);
    shipPart = _shipPart;
  }
}
