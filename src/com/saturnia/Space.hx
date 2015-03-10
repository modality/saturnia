package com.saturnia;

import com.haxepunk.graphics.Spritemap;
import com.modality.Base;
import com.modality.AugRandom;
import com.modality.Grid;
import com.modality.Block;

class Space extends Block
{
  public var grid:Grid<Space>;
  public var explored:Bool = false;
  public var locked:Bool = false;
  public var explorable:Bool = false;
  public var typeRevealed:Bool = false;

  public var frameSprite:Base;
  public var typeSprite:Base;
  public var lockedSprite:Base;

  public var encounter:Encounter;
  public var spaceType:SpaceType;

  public function new(_x:Int = 0, _y:Int = 0)
  {
    super(_x, _y);
    type = "space";
    layer = Constants.UNEXPLORED_LAYER;

    frameSprite = new Base(x, y);
    typeSprite = new Base(x, y);
    lockedSprite = new Base(x, y);

    spaceType = SpaceType.Voidness;
    locked = false;

    addChild(frameSprite);
    addChild(typeSprite);
    addChild(lockedSprite);
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
    frameSprite = Assets.getImage("space_explored");
    if(explored) {
      typeSprite.graphic = null;
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
        case Planet(x):
          var sm = new Spritemap(Assets.get("space_planet_sprite"), 100, 100);
          sm.add("play", [for(i in 0...190) i]);
          sm.play("play");
          graphic = sm;
        case Debris(x):
          var sm = new Spritemap(Assets.get("space_debris_sprite"), 100, 100);
          sm.add("play", [for(i in 0...64) i]);
          sm.play("play");
          graphic = sm;
        case Friendly(type):
          graphic = Assets.getImage("space_"+type);
        default:
          graphic = null;
      }
    } else {
      if(typeRevealed) {
      } else {
        typeSprite.graphic = null;
      }
      if(!locked) {
        lockedSprite.graphic = null;
      } else {
        lockedSprite.graphic = Asset.getImage("space_locked");
      }
      graphic = Assets.getImage("space_fog");
    }

    setHitbox(Constants.BLOCK_W, Constants.BLOCK_H, 0, 0);
  }

}
