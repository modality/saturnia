package com.saturnia;

import flash.events.Event;
import com.modality.AugRandom;

class MerchantEncounter extends Encounter
{
  public function new(_space:Space)
  {
    super(_space);
    type = "merchant";
    graphic = Assets.getImage("space_merchant");
  }

  public override function activate()
  {
    space.object = this;
    inventory.items = AugRandom.sample(MerchantGoods.currentGoods, 2);
    for(item in inventory.items) {
      item.addEventListener(Item.PURCHASED, boughtItem);
    }
  }

  public function boughtItem(event:Dynamic):Void
  {
    var item:Item = cast(cast(event, Event).currentTarget, Item);
    inventory.items.remove(item);
  }
}
