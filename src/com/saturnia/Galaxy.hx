package com.saturnia;

import openfl.events.Event;
import com.modality.Base;
import com.modality.Grid;

class Galaxy extends Base
{
  public static var CYCLE:String = "cycle";

  public var player:PlayerResources;
  public var sector:Sector;
  public var cards:Array<MajorArcana>;
  public var goods:Array<TradeGood>;
  public var sectors:Grid<Sector>;
  public var cardLocations:Array<Array<Int>>;

  public var hackAttempts:Int = 0;
  public var operatorsActive:Int = 0;
  public var cycleCounter:Int;
  public var policingContract:Int = 0;

  public function new()
  {
    super();
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
    for(good in goods) {
      player.cargos.set(good, 0);
    }
    player.addShipPart(ShipPartManager.getPart("Telescope"));
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

  public function resetCycleProgress()
  {
    cycleCounter = 0;
  }

  public function pulse()
  {
    cycleCounter--;
    if(cycleCounter == 0) {
      cycleCounter = Constants.TURNS_PER_CYCLE;
      player.cycle();
      dispatchEvent(new Event(CYCLE));
      if(policingContract > 0) {
        policingContract -= 1;
      }
    }
    player.pulse();
  }
}
