package com.saturnia;

import flash.events.Event;
import flash.display.BitmapData;
import com.haxepunk.graphics.Image;
import com.modality.Base;
import com.modality.TextBase;

class PlayerResources
{
  public var fuel:Int;
  public var shields:Int;
  public var cargo:Int;
  public var science:Int;

  public var maxFuel:Int;
  public var maxShields:Int;

  public var cards:Array<MajorArcana>;
  public var items:Array<Item>;
  public var shipParts:Array<ShipPart>;

  public var stats:CombatStats;

  public function new()
  {
    fuel = Constants.STARTING_FUEL;
    shields = Constants.STARTING_SHIELDS;
    cargo = Constants.STARTING_CARGO;
    science = Constants.STARTING_SCIENCE;

    maxFuel = fuel;
    maxShields = shields;

    cards = [];
    items = [];
    shipParts = [];

    shipParts.push(ShipPartManager.getPart("ShieldBattery"));

    stats = new CombatStats();
    stats.maxHitPoints = maxShields;
    stats.reset();
  }

  public function pulse():Void
  {
    for(sp in shipParts) {
      sp.pulse();
    }
  }

  public function useFuel(amount:Int)
  {
    fuel -= amount;
  }

  public function buyItem(item:Item)
  {
    if(cargo >= item.cargoCost && science >= item.scienceCost) {
      cargo -= item.cargoCost;
      science -= item.scienceCost;
      items.push(item);

      item.dispatchEvent(new Event(Item.PURCHASED));
      applyItem(item);
    }
  }

  public function applyItem(item:Item)
  {
    switch(item.itemType) {
      case Fuel:
        fuel += 10;
      case Charge:
        shields += 10;
      case Data:
        science += 5;
      default:
        trace("item not implemented :(");
    }
  }
}
