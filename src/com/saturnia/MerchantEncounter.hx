package com.saturnia;

import openfl.events.Event;
import com.modality.AugRandom;

class MerchantEncounter extends Encounter
{
  public var goods:Array<Item>;

  public var goodBought:String;
  public var goodSold:String;

  public var maxInventory:Int;
  public var refreshRate:Int;
  public var sellRate:Int;
  public var buyRate:Int;
  public var refreshTime:Int;
  public var goodInventory:Int;

  public function new(_space:Space)
  {
    super(_space);
    type = "merchant";
    graphic = Assets.getImage("space_merchant");
  }

  public override function activate()
  {
    space.object = this;
    goods = AugRandom.sample(MerchantGoods.currentGoods, 2);
    for(item in goods) {
      item.addEventListener(Item.PURCHASED, boughtItem);
    }
  }

  public function boughtItem(event:Dynamic):Void
  {
    var item:Item = cast(cast(event, Event).currentTarget, Item);
    goods.remove(item);
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

  public function pulse():Void
  {
    refreshTime += 1;
    goodInventory = calcInventory();
  }
}
