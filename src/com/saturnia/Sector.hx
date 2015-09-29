package com.saturnia;

import openfl.events.Event;
import com.modality.Grid;
import com.modality.Block;

class Sector
{
  public var explored:Bool;
  public var spaces:Grid<Space>;
  public var sectorType:SectorType;
  public var title:String;
  public var level:Int;
  public var goodsBought:Array<TradeGood>;
  public var goodsSold:Array<TradeGood>;
  public var cardLocations:Array<Array<Int>>;

  public function new()
  {
    explored = false;
    spaces = new Grid<Space>(Constants.GRID_X, Constants.GRID_Y, Constants.GRID_W, Constants.GRID_H);
    goodsBought = [];
    goodsSold = [];
    cardLocations = [];
  }

  public function cycle(e:Event):Void
  {
    if(!explored) return;

    spaces.each(function(space:Space, i:Int, j:Int) {
      switch(space.spaceType) {
        case Friendly(type):
          cast(space.encounter, FriendlyEncounter).cycle();
        default:
      }
    });
  }
}
