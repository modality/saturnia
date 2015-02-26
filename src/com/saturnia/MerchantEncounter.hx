package com.saturnia;

class MerchantEncounter extends FriendlyEncounter
{
  public var goodBought:String;
  public var goodSold:String;

  public var goodInventory:Int;
  public var maxInventory:Int;
  public var sellPrice:Int;
  public var buyPrice:Int;

  public var refreshRate:Int;
  public var refreshTime:Int;
  
  public override function activate()
  {
  }

  private function logistic(t:Float):Float
  {
    return 1. / (1. + Math.exp(-t));
  }

  private function logit(y:Float):Float
  {
    return -Math.log((1./y) -1.);
  }

  public function calcInventory():Int
  {
    return Math.ceil(logistic((12. * refreshTime / refreshRate) - 6.) * maxInventory);
  }

  public function calcTime():Int
  {
    return Math.floor(logit(1. * goodInventory / maxInventory) * refreshRate);
  }

  public override function cycle():Void
  {
    refreshTime += 1;
    goodInventory = calcInventory();
  }
}
