package com.saturnia;

import com.modality.Grid;

class Galaxy
{
  public var player:PlayerResources;
  public var cards:Array<MajorArcana>;
  public var goods:Array<String>;
  public var sectors:Grid<Sector>;
  public var cardLocations:Array<Array<Int>>;

  public var cycleCounter:Int;

  public function new()
  {
    cards = [];
    goods = [];
    cardLocations = [];
    sectors = new Grid<Sector>(0, 0, 5, 5);
    cycleCounter = Constants.TURNS_PER_CYCLE;
  }

  public function setupPlayer() {
    player = new PlayerResources();
    player.cards.push(cards[0]);
    player.cards.push(cards[1]);
    player.addShipPart(ShipPartManager.getPart("ShieldBattery"));
    player.addCrewMember(CrewMemberManager.getCrew("Planetologist"));
    player.addCrewMember(CrewMemberManager.getCrew("Astrochemist"));
  }

  public function getStartSector():Sector {
    if(Math.random() < 0.5) {
      return sectors.get(0, 1);
    } else {
      return sectors.get(1, 0);
    }
  }

  public function getSector(_x:MajorArcana, _y:MajorArcana):Sector
  {
    var x = 0;
    var y = 0;
    for(i in 0...cards.length) {
      if(cards[i] == _x) x = i;
      if(cards[i] == _y) y = i;
    }

    return sectors.get(x, y);
  }

  public function pulse()
  {
    cycleCounter--;
    if(cycleCounter == 0) {
      cycleCounter = Constants.TURNS_PER_CYCLE;
    }

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
