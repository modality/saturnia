package com.saturnia;

import openfl.events.Event;
import com.modality.Base;
import com.modality.Grid;

class Galaxy extends Base
{
  public static var CYCLE:String = "cycle";

  public var player:PlayerResources;
  public var grid:DeepGrid;
  public var goods:Array<TradeGood>;

  public var hackAttempts:Int = 0;
  public var operatorsActive:Int = 0;
  public var cycleCounter:Int;
  public var policingContract:Int = 0;

  public function new()
  {
    super();
    goods = [];
    cycleCounter = Constants.TURNS_PER_CYCLE;
  }

  public function setupPlayer() {
    player = new PlayerResources();
    for(good in goods) {
      player.cargos.set(good, 0);
    }
    player.addShipPart(ShipPartManager.getPart("Telescope"));
  }

  public function setupGrid() {
    grid = new DeepGrid(this);
  }

  public function getNewSector(level:Int):Sector
  {
    return Generator.generateSector(this, level);
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
