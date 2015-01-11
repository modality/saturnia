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

  public function pulse()
  {
    sectors.each(function(sector:Sector, u:Int, v:Int) {
      sector.spaces.each(function(space:Space, i:Int, j:Int) {
        if(space.spaceType == Friendly) {
          cast(space.encounter, MerchantEncounter).pulse();
        }
      });
    });
  }

  
}
