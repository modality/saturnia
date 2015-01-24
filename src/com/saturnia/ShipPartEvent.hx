package com.saturnia;

import openfl.events.Event;

class ShipPartEvent extends Event
{
  public static var TRY_USE:String = "try use ship part";
  public static var USE:String = "use ship part";
  public static var ADD:String = "add ship part";
  public static var PURCHASED:String = "purchased ship part";

  public var shipPart:ShipPart;

  public function new(type:String, _shipPart:ShipPart)
  {
    super(type);
    shipPart = _shipPart;
  }
}
