package com.saturnia;

import com.modality.Base;

class Item extends Base
{
  public static var PURCHASED:String = "purchased";

  public var itemType:ItemType;
  //public var efficacy:Int;
  public var description:String;

  public var scienceCost:Int;
  public var cargoCost:Int;

  public function new(_name:String, _type:ItemType, _sc:Int, _cc:Int)
  {
    super();
    name = _name;
    itemType = _type;
    scienceCost = _sc;
    cargoCost = _cc;
    description = MerchantGoods.descriptions.get(itemType);
  }
}
