package com.saturnia;

import com.haxepunk.graphics.Spritemap;
import com.modality.AugRandom;
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

  public function explore():Void
  {
    if(!explored) {
      explored = true;
      layer = Constants.EXPLORED_LAYER;
      updateGraphic();
      if(encounter != null) {
        encounter.activate();

        encounter.x = 0;
        encounter.y = 0;
        encounter.layer = Constants.EXPLORED_LAYER;
        addChild(encounter);
      }
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
    super.updateGraphic();
    if(explored) {
      switch(spaceType) {
        case Star, Start:
          //graphic = Assets.getImage("space_star");
          var star_str = AugRandom.sample(["space_star_blue", "space_star_red", "space_star_yellow"])[0];
          var sm = new Spritemap(Assets.get(star_str), 100, 100);
          sm.add("play", [for(i in 0...48) i]);
          sm.play("play");
          graphic = sm;
        case Exit:
          var sm = new Spritemap(Assets.get("space_star_exit"), 100, 100);
          sm.add("play", [for(i in 0...48) i]);
          sm.play("play");
          graphic = sm;
        case Planet:
          var sm = new Spritemap(Assets.get("space_planet_sprite"), 100, 100);
          sm.add("play", [for(i in 0...190) i]);
          sm.play("play");
          graphic = sm;
        case Debris:
          var sm = new Spritemap(Assets.get("space_debris_sprite"), 100, 100);
          sm.add("play", [for(i in 0...64) i]);
          sm.play("play");
          graphic = sm;
        case Friendly:
          graphic = Assets.getImage("space_friendly");
        case Hostile:
          graphic = Assets.getImage("space_hostile");
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
