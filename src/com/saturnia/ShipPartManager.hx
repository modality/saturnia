package com.saturnia;

import com.modality.AugRandom;
import com.modality.cards.Message;

class ShipPartManager
{
  //public static var merchantParts:Array<String>;

  public static function getPart(id:String):ShipPart
  {
    var shipPartData:Data.ShipParts = Data.shipParts.resolve(id);
    var part:ShipPart = new ShipPart();

    part.name = shipPartData.name;
    part.level = shipPartData.level;
    part.description = shipPartData.description;
    part.energyCost = shipPartData.energyCost;
    part.activeEffect = shipPartData.activeEffect;
    part.soundEffect = shipPartData.soundEffect;
    part.effectName = shipPartData.effectName;
    part.effect = Message.read(shipPartData.effects);

    part.reset();
    return part;
  }

  public static function getParts(count:Int, level:Int = 0):Array<ShipPart>
  {
    var merchantParts = [];
    if(level > 0) {
      merchantParts = [for(p in Data.shipParts.all) if(p.inMerchant && p.level <= level) p.id.toString()];
    } else {
      merchantParts = [for(p in Data.shipParts.all) if(p.inMerchant) p.id.toString()];
    }

    var sample = AugRandom.sample(merchantParts, count);
    return [for(p in sample) getPart(p)];
  }

}
