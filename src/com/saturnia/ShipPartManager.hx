package com.saturnia;

import com.modality.AugRandom;
import com.modality.cards.Message;

class ShipPartManager
{
  public static var merchantParts:Array<String>;

  public static function getPart(id:String):ShipPart
  {
    var shipPartData:Data.ShipParts = Data.shipParts.resolve(id);
    var part:ShipPart = new ShipPart();

    part.name = shipPartData.name;
    part.description = shipPartData.description;
    part.scienceCost = shipPartData.scienceCost;
    part.cargoCost = shipPartData.cargoCost;
    part.activeEffect = shipPartData.activeEffect;
    part.refreshRate = shipPartData.refreshRate;
    part.refreshLevels = shipPartData.refreshLevels;
    part.soundEffect = shipPartData.soundEffect;
    part.effectName = shipPartData.effectName;
    part.effects = Message.read(shipPartData.effects);

    part.reset();
    return part;
  }

  public static function getMerchantParts(count:Int):Array<ShipPart>
  {
    if(merchantParts == null) {
      merchantParts = [for(p in Data.shipParts.all) if(p.inMerchant) p.id.toString()];
    }

    var sample = AugRandom.sample(merchantParts, count);
    return [for(p in sample) getPart(p)];
  }

}
