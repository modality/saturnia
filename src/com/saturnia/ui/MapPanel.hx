package com.saturnia.ui;

import com.modality.Base;
import com.modality.Grid;

class MapPanel extends Base {
  public var sector:Sector;
  public var grid:Grid<Space>;

  public function new(_galaxy:Galaxy)
  {
    super(0, 0);
    navigateTo(_galaxy.getStartSector());
    _galaxy.sector = sector;
  }

  public function tryExplore(space:Space):Bool
  {
    if(canExplore(space)) {
      space.explore();
      return true;
    }
    return false;
  }

  public function canExplore(space:Space):Bool
  {
    if(space.explored) return false;
    if(space.locked) return false;

    var s:Space;

    s = grid.get(space.x_index-1, space.y_index);
    if(s != null && s.explored) return true;
    s = grid.get(space.x_index+1, space.y_index);
    if(s != null && s.explored) return true;
    s = grid.get(space.x_index, space.y_index-1);
    if(s != null && s.explored) return true;
    s = grid.get(space.x_index, space.y_index+1);
    if(s != null && s.explored) return true;

    return false;
  }

  public function navigateTo(_sector:Sector):Void
  {
    /*
    if(navigationPanel != null) {
      exitNavigation();
    }
    */
    if(grid != null) {
      grid.each(function(space:Space, i:Int, j:Int) {
        removeChild(space);
      });
    }

    sector = _sector;
    sector.explored = true;
    grid = sector.spaces;

    grid.each(function(space:Space, i:Int, j:Int) {
      space.updateGraphic();
      if(space.spaceType == Start && !space.explored) {
        space.spaceType = Star;
        space.explore();
      }
      addChild(space);
    });
  }

  public function checkLocked(canExploreNearPirate:Bool):Void
  {
    grid.each(function(s:Space, i:Int, j:Int):Void {
      if(!s.explored) {
        s.locked = false;
        for(nayb in grid.neighbors(s, true)) {
          if(nayb.explored && (nayb.hasObject("pirate") && !canExploreNearPirate)) {
            s.locked = true; 
          }
        }
        s.updateGraphic();
      }
    });
  }

  public function getPirates():Array<PirateEncounter>
  {
    var pirates:Array<PirateEncounter> = [];
    grid.each(function(space:Space, i:Int, j:Int):Void {
      if(space.explored && space.spaceType == Hostile) {
        if(space.encounter != null) {
          var pe:PirateEncounter = cast(space.encounter, PirateEncounter);
          if(!pe.stats.isDead()) {
            pirates.push(pe);
          }
        }
      }
    });
    return pirates;
  }
}
