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
    crewMembers = [];
    shipParts = [];
  }

  public override function cycle():Void
  {
    super.cycle();
    removeStatusEffect("overdrive");
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
    if(hasStatusEffect("overdrive")) {
      amount *= 2;
    }
    fuel -= amount;
    updated();
  }

  public function addResource(resource:String, amount:Int):Void
  {
    switch(resource) {
      case "fuel": fuel += amount;
      case "science": science += amount;
      case "energy": energy += amount;
    }
  }

  public function getResource(resource:String):Int
  {
    switch(resource) {
      case "fuel": return fuel;
      case "science": return science;
      case "energy": return energy;
    }
    return 0;
  }

  public function addCargo(tradeGood:TradeGood, amount:Int):Void
  {
    cargos.set(tradeGood, cargos.get(tradeGood) + amount);
  }

  public function totalCargo():Int
  {
    var total = 0;
    for(i in cargos) {
      total += i;
    }
    return total;
  }

  public function spendCargo(amount:Int):Void
  {
    var total = totalCargo();
    var newTotal = 0;
    var keys = [for(k in cargos.keys()) k];
    keys.sort(function(a:TradeGood, b:TradeGood) { return cargos.get(b) - cargos.get(a); });

    for(k in keys) {
      if(amount == total || cargos.get(k) == 0) {
        cargos.set(k, 0);
      } else {
        var newAmount = Math.ceil(cargos.get(k) * (1 - (amount / total))); 
        cargos.set(k, newAmount);
        newTotal += newAmount;
      }
    }

    var diff = (amount + newTotal) - total;

    for(i in 0...diff) {
      cargos.set(keys[i], cargos.get(keys[i]) - 1);
    }
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
