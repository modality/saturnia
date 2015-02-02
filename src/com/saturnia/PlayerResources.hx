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

  public var energy:Int;

  public var maxFuel:Int;
  public var maxShields:Int;
  public var maxEnergy:Int;

  public var cards:Array<MajorArcana>;
  public var crewMembers:Array<CrewMember>;
  public var shipParts:Array<ShipPart>;

  public var stats:CombatStats;

  public function new()
  {
    super();
    fuel = Constants.STARTING_FUEL;
    shields = Constants.STARTING_SHIELDS;
    cargo = Constants.STARTING_CARGO;
    science = Constants.STARTING_SCIENCE;
    energy = Constants.STARTING_ENERGY;

    maxFuel = fuel;
    maxShields = shields;
    maxEnergy = energy;

    cards = [];
    crewMembers = [];
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

  public function cycle():Void
  {
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

  public function addCrewMember(crewMember:CrewMember)
  {
    crewMembers.push(crewMember);
    stats.addStatusEffect(StatusEffect.fromCrewMember(crewMember));
  }

  public function addShipPart(shipPart:ShipPart)
  {
    shipParts.push(shipPart);
    shipPart.addEventListener(EffectEvent.APPLY, applyEffect);
    if(!shipPart.activeEffect) {
      stats.addStatusEffect(StatusEffect.fromShipPart(shipPart));
    }
    var ev = new ShipPartEvent(ShipPartEvent.ADD, shipPart);
    dispatchEvent(ev);
  }

  public function buyShipPart(shipPart:ShipPart):Bool
  {
    if(cargo >= shipPart.cargoCost && science >= shipPart.scienceCost) {
      cargo -= shipPart.cargoCost;
      science -= shipPart.scienceCost;
      addShipPart(shipPart);
      shipPart.dispatchEvent(new ShipPartEvent(ShipPartEvent.PURCHASED, shipPart));
      updated();
      return true;
    }
    return false;
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
}
