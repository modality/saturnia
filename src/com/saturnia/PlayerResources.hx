package com.saturnia;

import openfl.display.BitmapData;
import openfl.events.Event;
import com.haxepunk.graphics.Image;
import com.modality.Base;
import com.modality.TextBase;
import com.modality.cards.Message;

class PlayerResources extends Base
{
  public static var UPDATED:String = "player resources updated";

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
    super();
    fuel = Constants.STARTING_FUEL;
    shields = Constants.STARTING_SHIELDS;
    cargo = Constants.STARTING_CARGO;
    science = Constants.STARTING_SCIENCE;

    maxFuel = fuel;
    maxShields = shields;

    cards = [];
    items = [];
    shipParts = [];

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

  public function updated():Void
  {
    dispatchEvent(new Event(UPDATED));
  }

  public function useFuel(amount:Int)
  {
    fuel -= amount;
    updated();
  }

  public function addShipPart(shipPart:ShipPart)
  {
    shipParts.push(shipPart);
    shipPart.addEventListener(EffectEvent.APPLY, applyEffect);
    var ev = new ShipPartEvent(ShipPartEvent.ADD, shipPart);
    dispatchEvent(ev);
  }

  public function buyItem(item:Item)
  {
    if(cargo >= item.cargoCost && science >= item.scienceCost) {
      cargo -= item.cargoCost;
      science -= item.scienceCost;
      items.push(item);

      //item.dispatchEvent(new Event(Item.PURCHASED));
      applyItem(item);
    }
  }

  public function applyEffect(ev:EffectEvent)
  {
    var msg:Message = ev.effect;

    switch(msg.type()) {
      case "heal":
        stats.hitPoints += Std.int(msg.tokens[1]);
        if(stats.hitPoints > stats.maxHitPoints) stats.hitPoints = stats.maxHitPoints;
        shields = stats.hitPoints;
      default:
    }
    updated();
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
