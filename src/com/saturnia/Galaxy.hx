package com.saturnia;

import com.modality.Grid;

class Galaxy
{
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
}
