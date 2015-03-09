package com.saturnia;

import openfl.display.BitmapData;
import openfl.events.Event;
import com.modality.cards.Message;

class PlayerResources extends CombatStats
{
  public static var UPDATED:String = "player resources updated";

  public var fuel:Int;
  public var science:Int;
  public var energy:Int;
  public var maxEnergy:Int;

  public var cargos:Map<TradeGood, Int>;
  public var cards:Array<MajorArcana>;
  public var crewMembers:Array<CrewMember>;
  public var shipParts:Array<ShipPart>;

  public function new()
  {
    super();
    fuel = Constants.STARTING_FUEL;
    science = Constants.STARTING_SCIENCE;
    energy = Constants.STARTING_ENERGY;
    maxEnergy = energy;

    progInitiative = 1;
    progEvasion = 1;
    progDamage = 1;
    progShield = 1;

    shieldLevel = progShield;

    cargos = new Map<TradeGood, Int>();
    cards = [];
    crewMembers = [];
    shipParts = [];
  }

  public override function cycle():Void
  {
    super.cycle();
    energy = maxEnergy;
    for(sp in shipParts) {
      sp.reset();
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

  public function addResource(resource:String, amount:Int)
  {
    switch(resource) {
      case "fuel": fuel += amount;
      case "science": science += amount;
      case "energy": energy += amount;
    }
  }

  public function addCargo(tradeGood:TradeGood, amount:Int):Void
  {
    cargos.set(tradeGood, cargos.get(tradeGood) + amount);
  }

  public function totalCargo():Int
  {
    return 0;
  }

  public function spendCargo(amount:Int):Void
  {
  }

  public function addCrewMember(crewMember:CrewMember)
  {
    crewMembers.push(crewMember);
  }

  public function addShipPart(shipPart:ShipPart)
  {
    shipParts.push(shipPart);
  }
}
