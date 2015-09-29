package com.saturnia;

import com.haxepunk.graphics.Spritemap;
import com.modality.Base;
import com.modality.AugRandom;
import com.modality.Grid;
import com.modality.Block;

class Space extends Block
{
  public var sector:Sector;
  public var grid:Grid<Space>;
  public var explored:Bool = false;
  public var locked:Bool = false;
  public var explorable:Bool = false;
  public var typeRevealed:Bool = false;

  public var underlaySprite:Base;
  public var terrainSprite:Base;
  public var encounterSprite:Base;
  public var typeSprite:Base;
  public var lockedSprite:Base;

  public var encounter:Encounter;
  public var spaceType:SpaceType;

  public function new(_x:Int = 0, _y:Int = 0)
  {
    super(_x, _y);
    type = "space";
    layer = Constants.UNEXPLORED_LAYER;

    graphic = Assets.getImage("space_frame");

    underlaySprite = new Base(x, y);
    terrainSprite = new Base(x, y);
    encounterSprite = new Base(x, y);
    typeSprite = new Base(x, y);
    lockedSprite = new Base(x, y);

    spaceType = SpaceType.Voidness;
    locked = false;

    addChild(underlaySprite);
    addChild(terrainSprite);
    addChild(encounterSprite);
    addChild(typeSprite);
    addChild(lockedSprite);
  }

  public function explore():Void
  {
    trace("spluring");
    if(!explored) {
      explored = true;
      updateGraphic();
      if(encounter != null) {
        encounter.activate();
      }
    }
  }

  public function revealType():Void
  {
    if(!typeRevealed) {
      typeRevealed = true;
      updateGraphic();
    }
  }

  public function removeEncounter():Void
  {
    spaceType = SpaceType.Voidness;
    if(encounter != null) {
      removeChild(encounter);
      encounter = null;
    }
    updateGraphic();
    objects = [];
  }

  public override function updateGraphic():Void
  {
    super.updateGraphic();
    if(explored) {
      trace("explured");
      var underlay = "sector_underlay_" + switch(sector.level % 3) {
        case 0: "blue";
        case 1: "green";
        case 2: "red";
        default: "red";
      };
      underlaySprite.graphic = Assets.getImage(underlay);

      switch(spaceType) {
        case Star, Start:
          //graphic = Assets.getImage("space_star");
          var star_str = AugRandom.sample(["space_star_blue", "space_star_red", "space_star_yellow"])[0];
          var sm = new Spritemap(Assets.get(star_str), 100, 100);
          sm.add("play", [for(i in 0...48) i]);
          sm.play("play");
          terrainSprite.graphic = sm;
        case Exit:
          var sm = new Spritemap(Assets.get("space_star_exit"), 100, 100);
          sm.add("play", [for(i in 0...48) i]);
          sm.play("play");
          terrainSprite.graphic = sm;
        case Planet(x):
          trace("got planet");
          var sm = new Spritemap(Assets.get("space_planet_sprite"), 100, 100);
          sm.add("play", [for(i in 0...190) i]);
          sm.play("play");
          terrainSprite.graphic = sm;
        case Debris(x):
          var sm = new Spritemap(Assets.get("space_debris_sprite"), 100, 100);
          sm.add("play", [for(i in 0...64) i]);
          sm.play("play");
          terrainSprite.graphic = sm;
        case Friendly(type):
          terrainSprite.graphic = null;
          encounterSprite.graphic = Assets.getImage("space_"+type);
        default:
          terrainSprite.graphic = null;
      }
    } else {
      if(typeRevealed) {
        switch(spaceType) {
          case Friendly(type):
            typeSprite.graphic = Assets.getImage("overlay_friendly");
          case Hostile:
            typeSprite.graphic = Assets.getImage("overlay_hostile");
          default:
            typeSprite.graphic = Assets.getImage("overlay_space");
        }
      } else {
        typeSprite.graphic = null;
      }
      if(locked) {
        lockedSprite.graphic = Assets.getImage("space_locked");
      } else {
        lockedSprite.graphic = null;
      }
      //graphic = Assets.getImage("space_fog");
    }

    setHitbox(Constants.BLOCK_W, Constants.BLOCK_H, 0, 0);
  }

}
