package com.saturnia.ui;

import com.modality.Base;

class MapPanel extends Base {
  public var grid:DeepGrid;
  public var sector:Sector;
  //public var grid:Grid<Space>;

  public function new(_galaxy:Galaxy)
  {
    super(0, 0);
    grid = _galaxy.grid;
    addChild(grid);
  }

  public function tryExplore(space:Space):Bool
  {
    return grid.explore(space);
  }

  public function checkLocked(canExploreNearPirate:Bool):Void
  {
    grid.checkLocked(canExploreNearPirate);
  }

  public function getPirates():Array<PirateEncounter>
  {
    return grid.getPirates();
  }
}
