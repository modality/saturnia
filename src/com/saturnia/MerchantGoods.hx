package com.saturnia;

import haxe.EnumTools;
import flash.events.Event;
import com.modality.AugRandom;

class MerchantGoods
{
  public static var currentGoods:Array<Item>;
  public static var names:Map<ItemType, String>;
  public static var descriptions:Map<ItemType, String>;

  public static function init():Void
  {
    currentGoods = [];
    names = [
      ItemType.Uncertainty => "Uncertainty %suffix%",
      ItemType.Science     => "Science %suffix%",
      ItemType.Shield      => "Shield %suffix%",
      ItemType.Tractor     => "Tractor %suffix%",
      ItemType.Battery     => "%prefix% Batteries",
      ItemType.Resistor    => "%prefix% Resistors",
      ItemType.Tether      => "%prefix% Tethers",
      ItemType.Cell        => "%prefix% Cells",
      ItemType.Tank        => "%prefix% Tanks",
      ItemType.Capacitor   => "%prefix% Capacitors",
      ItemType.Fuel        => "Fuel",
      ItemType.Charge      => "Shield Charge",
      ItemType.Data        => "%prefix% Data"
    ];

    descriptions = [
      ItemType.Uncertainty => "Doubles gains and losses",
      ItemType.Science     => "Increases science gains",
      ItemType.Shield      => "Increases shield gains",
      ItemType.Tractor     => "Increases cargo and fuel gains",
      ItemType.Battery     => "Increases maximum shields",
      ItemType.Resistor    => "Protects computers from energy surges",
      ItemType.Tether      => "Protects cargo from bumps and bruises",
      ItemType.Cell        => "Increases fuel efficiency",
      ItemType.Tank        => "Increases maximum fuel",
      ItemType.Capacitor   => "Increases shield strength",
      ItemType.Fuel        => "+10 fuel",
      ItemType.Charge      => "+10 shields",
      ItemType.Data        => "+5 science"
    ];

    addItem(ItemType.Fuel);
    addItem(ItemType.Charge);
    addItem(ItemType.Data);
    addItem();
    addItem();
    addItem();
  }

  public static function addItem(?itemType:ItemType):Void
  {
    if(itemType == null) {
      var itemTypes = EnumTools.createAll(ItemType);

      for(item in currentGoods) {
        itemTypes.remove(item.itemType);
      }

      itemType = AugRandom.sample(itemTypes)[0];
    } 

    var itemName = names.get(itemType);
    itemName = StringTools.replace(itemName, "%prefix%", AugRandom.sample(Generator.good_1)[0]);
    itemName = StringTools.replace(itemName, "%suffix%", AugRandom.sample(Generator.good_2_singular)[0]);

    var scienceCost = 0, cargoCost = 0;

    switch(itemType) {
      case Uncertainty:
        scienceCost = 10;
      case Tractor:
        scienceCost = 8;
      case Fuel:
        cargoCost = 5;
      case Charge, Data:
        cargoCost = 10;
      default:
        scienceCost = 5;
    }
    
    currentGoods.push(new Item(itemName, itemType, scienceCost, cargoCost));
  }

  public static function boughtItem(event:Dynamic)
  {
    var item:Item = cast(cast(event, Event).currentTarget, Item);

    switch(item.itemType) {
      case Fuel, Charge:
        return;
      case Data:
        currentGoods.remove(item);
        addItem(ItemType.Data);
      default:
        currentGoods.remove(item);
    }
  }
}
