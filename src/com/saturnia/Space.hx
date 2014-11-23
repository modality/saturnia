package com.saturnia;

import com.modality.Grid;
import com.modality.Block;

class Space extends Block
{
  public var grid:Grid<Space>;
  public var explored:Bool = false;
  public var locked:Bool = false;
  public var encounter:Encounter;
  public var spaceType:SpaceType;

  public function new(_x:Int = 0, _y:Int = 0)
  {
    super(_x, _y);
    type = "space";
    layer = Constants.UNEXPLORED_LAYER;
    spaceType = SpaceType.Voidness;
    locked = false;
  }

  public override function removed()
  {
    scene.remove(encounter);
    encounter = null;
  }

  public function explore():Void
  {
    if(!explored) {
      explored = true;
      layer = Constants.EXPLORED_LAYER;
      updateGraphic();
      if(encounter != null) {
        encounter.activate();

        encounter.x = x;
        encounter.y = y;
        encounter.layer = Constants.EXPLORED_LAYER;
        scene.add(encounter);
      }
    }
  }

  public function removeEncounter():Void
  {
    spaceType = SpaceType.Voidness;
    scene.remove(encounter);
    encounter = null;
    updateGraphic();
    objects = [];
  }

  public override function updateGraphic():Void
  {
    super.updateGraphic();
    if(explored) {
      switch(spaceType) {
        case Star:
          graphic = Assets.getImage("space_star");
        case Planet:
          graphic = Assets.getImage("space_planet");
        default:
          graphic = null;
      }
    } else {
      if(!locked) {
        graphic = Assets.getImage("space_unexplored");
      } else {
        graphic = Assets.getImage("space_locked");
      }
    }

    setHitbox(Constants.BLOCK_W, Constants.BLOCK_H, 0, 0);
  }

}
