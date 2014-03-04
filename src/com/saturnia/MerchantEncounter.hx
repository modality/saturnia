package com.saturnia;

import flash.events.Event;
import com.modality.AugRandom;

class MerchantEncounter extends Encounter
{
  public var goods:Array<Item>;

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
}
