package com.saturnia;

class MerchantEncounter extends FriendlyEncounter
{
  public var goodBought:TradeGood;
  public var goodSold:TradeGood;

  public var goodRatio:Int;
  public var fuelRatio:Int;

  public var goodInventory:Int;
  public var fuelInventory:Int;

  public override function activate()
  {
    cycle();
  }

  public override function cycle():Void
  {
    goodRatio = Std.random(5) + 1;
    fuelRatio = 1;

    goodInventory = switch(goodRatio) {
      case 1: 100;
      case 2: 80;
      case 3: 60;
      case 4: 40;
      case 5: 20;
      default: 0;
    };

    fuelInventory = 10;
  }
}
