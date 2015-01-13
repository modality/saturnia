package com.saturnia;

import com.modality.cards.Message;

class ShipPartManager
{
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
    part.effects = Message.read(shipPartData.effects);

    part.reset();
    return part;
  }
}
