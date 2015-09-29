package com.saturnia;

import openfl.events.Event;
import com.modality.Base;
import com.modality.Grid;

class DeepGrid extends Base {
  public static var SECTOR_COMPLETE:String = "sector complete";

  public var galaxy:Galaxy;
  public var sectors:Array<Sector>;
  public var spaces:Grid<Space>;

  public var lowestLevel:Int;

  public function new(_galaxy:Galaxy)
  {
    super(0, 0);
    galaxy = _galaxy;
    sectors = [];
    lowestLevel = 0;
    spaces = new Grid<Space>(Constants.GRID_X, Constants.GRID_Y, Constants.GRID_W, Constants.GRID_H);
    spaces.init(function(i:Int, j:Int):Space {
      return new Space();
    });
    getSector(0).spaces.each(function(s:Space, i:Int, j:Int):Void {
      spaces.set(i, j, s);
      addChild(s);
      s.updateGraphic();
    });
  }

  public function explore(space:Space):Bool
  {
    if(space.locked) return false;

    var s:Space;

    s = spaces.get(space.x_index-1, space.y_index);
    if(s != null && s.sector.level < space.sector.level) return false;
    s = spaces.get(space.x_index+1, space.y_index);
    if(s != null && s.sector.level < space.sector.level) return false;
    s = spaces.get(space.x_index, space.y_index-1);
    if(s != null && s.sector.level < space.sector.level) return false;
    s = spaces.get(space.x_index, space.y_index+1);
    if(s != null && s.sector.level < space.sector.level) return false;

    var sector = getSector(space.sector.level + 1);
    var x_index = space.x_index;
    var y_index = space.y_index;

    var newSpace = sector.spaces.get(x_index, y_index);
    spaces.set(x_index, y_index, sector.spaces.get(x_index, y_index));
    
    removeChild(space);
    addChild(newSpace);

    newSpace.explore();
    newSpace.updateGraphic();
    
    var newLowLevel = newSpace.sector.level;
    spaces.each(function(s:Space, i:Int, j:Int):Void {
      if(s.sector.level < newLowLevel) {
        newLowLevel = s.sector.level;
      }
    });

    if(newLowLevel > lowestLevel) {
      dispatchEvent(new Event(SECTOR_COMPLETE));
      lowestLevel = newLowLevel;
    }

    return true;
  }

  public function getSector(level:Int):Sector
  {
    for(sector in sectors) {
      if(sector.level == level) {
        return sector;
      }
    }
    var sector = galaxy.getNewSector(level);
    sectors.push(sector);
    return sector;
  }

  public function checkLocked(canExploreNearPirate:Bool):Void
  {
    spaces.each(function(s:Space, i:Int, j:Int):Void {
      if(!s.explored) {
        s.locked = false;
        for(nayb in spaces.neighbors(s, true)) {
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
    spaces.each(function(space:Space, i:Int, j:Int):Void {
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
