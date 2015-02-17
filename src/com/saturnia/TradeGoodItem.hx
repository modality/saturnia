package com.saturnia;

import com.modality.Base;

class TradeGoodItem extends Base implements Purchasable
{
  public var infinited:Bool;
  public var description:String;
  public var amount:Int;
  public var cargoCost:Int;
  public var scienceCost:Int;

  public function displayName():String
  {
    return name + " ("+amount+")";
  }

  public function displayDescription():String
  {
    return description;
  }

  public function canPurchase(player:PlayerResources):Boolean
  {
    return player.cargo >= cargoCost && player.science >= scienceCost;
  }

  public function onPurchase(event:PurchaseEvent):Void
  {
    event.player.cargo -= cargoCost;
    event.player.science -= scienceCost;
    event.player.addResource(resource, amount);
  }
}

