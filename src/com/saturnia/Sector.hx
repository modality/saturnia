package com.saturnia;

import com.modality.Grid;
import com.modality.Block;

class Sector extends Block
{
  public var spaces:Grid<Space>;
  public var sectorType:SectorType;
  public var title:String;
  public var level:Int;
  public var tarot_x:MajorArcana;
  public var tarot_y:MajorArcana;
  public var goodsBought:Array<String>;
  public var goodsSold:Array<String>;
  public var cardLocations:Array<Array<Int>>;

  public function new()
  {
    super(0, 0);
    spaces = new Grid<Space>(Constants.GRID_X, Constants.GRID_Y, Constants.GRID_W, Constants.GRID_H);
    goodsBought = [];
    goodsSold = [];
    cardLocations = [];
  }
}
