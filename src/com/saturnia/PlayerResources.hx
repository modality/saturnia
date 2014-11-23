package com.saturnia;

import flash.events.Event;
import com.modality.Base;
import com.modality.TextBase;

class PlayerResources extends Base
{
  public var fuel:Int;
  public var shields:Int;
  public var cargo:Int;
  public var science:Int;

  public var maxFuel:Int;
  public var maxShields:Int;

  public var items:Array<Item>;

  public var fuel_icon:Base;
  public var fuel_text:TextBase;
  public var shields_icon:Base;
  public var shields_text:TextBase;
  public var cargo_icon:Base;
  public var cargo_text:TextBase;
  public var science_icon:Base;
  public var science_text:TextBase;

  public function new()
  {
    super();

    fuel = Constants.STARTING_FUEL;
    shields = Constants.STARTING_SHIELDS;
    cargo = Constants.STARTING_CARGO;
    science = Constants.STARTING_SCIENCE;

    maxFuel = fuel;
    maxShields = shields;

    items = [];

    fuel_icon = new Base(0, 0, Assets.getImage("icon_fuel"));
    fuel_text = new TextBase(25, 1, 45, 20, ""+fuel);
    fuel_text.color = Constants.FUEL_COLOR;
    fuel_icon.layer = Constants.RESOURCE_LAYER;
    fuel_text.layer = Constants.RESOURCE_LAYER;

    shields_icon = new Base(70, 0, Assets.getImage("icon_shields"));
    shields_text = new TextBase(95, 1, 45, 20, ""+shields);
    shields_text.color = Constants.SHIELDS_COLOR;
    shields_icon.layer = Constants.RESOURCE_LAYER;
    shields_text.layer = Constants.RESOURCE_LAYER;

    cargo_icon = new Base(140, 0, Assets.getImage("icon_cargo"));
    cargo_text = new TextBase(165, 1, 45, 20, ""+cargo);
    cargo_text.color = Constants.CARGO_COLOR;
    cargo_icon.layer = Constants.RESOURCE_LAYER;
    cargo_text.layer = Constants.RESOURCE_LAYER;

    science_icon = new Base(210, 0, Assets.getImage("icon_science"));
    science_text = new TextBase(235, 1, 45, 20, ""+science);
    science_text.color = Constants.SCIENCE_COLOR;
    science_icon.layer = Constants.RESOURCE_LAYER;
    science_text.layer = Constants.RESOURCE_LAYER;
  }

  public override function added()
  {
    scene.add(fuel_icon);
    scene.add(fuel_text);
    scene.add(shields_icon);
    scene.add(shields_text);
    scene.add(cargo_icon);
    scene.add(cargo_text);
    scene.add(science_icon);
    scene.add(science_text);
  }

  public function useFuel(amount:Int)
  {
    fuel -= amount;
    fuel_text.text = ""+fuel;
  }

  public function buyItem(item:Item)
  {
    if(cargo >= item.cargoCost && science >= item.scienceCost) {
      cargo -= item.cargoCost;
      science -= item.scienceCost;
      items.push(item);

      item.dispatchEvent(new Event(Item.PURCHASED));
      applyItem(item);
      updateGraphic();
    }
  }

  public function applyResult(result:CombatResult)
  {
    switch(result.reactionElement) {
      case "air":
        science -= result.penaltyAmount;
        if(science < 0) science = 0;
      case "water":
        shields -= result.penaltyAmount;
        if(shields < 0) shields = 0;
      case "fire":
        fuel -= result.penaltyAmount;
        if(fuel < 0) fuel = 0;
      case "earth":
        cargo -= result.penaltyAmount;
        if(cargo < 0) cargo = 0;
      default:
    }

    switch(result.resultElement) {
      case "air":
        science += result.rewardAmount;
      case "water":
        shields += result.rewardAmount;
        if(shields > maxShields) shields = maxShields;
      case "fire":
        fuel += result.rewardAmount;
        if(fuel > maxFuel) fuel = maxFuel;
      case "earth":
        cargo += result.rewardAmount;
      default:
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

  public override function updateGraphic()
  {
    super.updateGraphic();
    fuel_text.text = ""+fuel;
    shields_text.text = ""+shields;
    cargo_text.text = ""+cargo;
    science_text.text = ""+science;
  }
}
