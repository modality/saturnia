package com.saturnia;

import com.modality.Grid;
import com.modality.Block;

class Space extends Block
{
  public var grid:SpaceGrid;
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

  public function explore(_st:SpaceType):Void
  {
    if(!explored) {
      explored = true;
      layer = Constants.EXPLORED_LAYER;

      spaceType = _st;
      /*
      if(spaceType == SpaceType.Hostile) {
        encounter = new PirateEncounter(this);
      } else if(spaceType == SpaceType.Friendly) {
        encounter = new MerchantEncounter(this);
      }

      if(encounter != null) {
        encounter.activate();
        encounter.x = x;
        encounter.y = y;
        encounter.layer = Constants.EXPLORED_LAYER;
        addChild(encounter);
      }
      */
      updateGraphic();
    }
  }

  public function removeEncounter():Void
  {
    spaceType = SpaceType.Voidness;
    removeChild(encounter);
    encounter = null;
    updateGraphic();
    objects = [];
  }

  public override function updateGraphic():Void
  {
    super.update();
    if(explored) {
      graphic = Generator.spaceImage(spaceType);
    } else {
      if(!locked) {
        graphic = Assets.getSprite("tile_tex", 0, 0, 100, 100);
      } else {
        graphic = Assets.getSprite("tile_tex", 300, 0, 100, 100);
      }
    }

    setHitbox(Constants.BLOCK_W, Constants.BLOCK_H, 0, 0);
  }

}
