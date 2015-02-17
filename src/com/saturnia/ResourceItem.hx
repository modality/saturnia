package com.saturnia;

import com.modality.Base;

class ResourceItem extends Base implements Purchasable
{
  public var infinite:Bool;
  public var description:String;
  public var resource:String;
  public var amount:Int;
  public var cargoCost:Int;
  public var scienceCost:Int;

  public function displayName():String
  {
    var str = resource;
    return resource + " ("+amount+")";
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
