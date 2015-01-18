package com.saturnia;

import com.modality.Grid;

class Galaxy
{
  public var player:PlayerResources;
  public var cards:Array<MajorArcana>;
  public var goods:Array<String>;
  public var sectors:Grid<Sector>;
  public var cardLocations:Array<Array<Int>>;

  public function new()
  {
    cards = [];
    goods = [];
    cardLocations = [];
    sectors = new Grid<Sector>(0, 0, 5, 5);
  }

  public function setupPlayer() {
    player = new PlayerResources();
    player.cards.push(cards[0]);
    player.cards.push(cards[1]);
    player.addShipPart(ShipPartManager.getPart("ShieldBattery"));
  }

  public function getStartSector():Sector {
    if(Math.random() < 0.5) {
      return sectors.get(0, 1);
    } else {
      return sectors.get(1, 0);
    }
  }

  public function pulse()
  {
    player.pulse();
    sectors.each(function(sector:Sector, u:Int, v:Int) {
      sector.spaces.each(function(space:Space, i:Int, j:Int) {
        if(space.spaceType == Friendly) {
          cast(space.encounter, MerchantEncounter).pulse();
        }
      });
    });
  }

  
}
