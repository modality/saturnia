package com.saturnia;

import flash.geom.Point;
import com.modality.Grid;
import com.haxepunk.graphics.TiledImage;
import com.modality.Base;

class SpaceGrid extends Grid<Space>
{
  public var grid_bg:Base;
  public var offsetX:Float = 0;
  public var offsetY:Float = 0;
  public var openSpots:Array<Point>;

  /*
  public function new()
  {
    super();
    openSpots = [];
  }
  */

  public function initBackground():Void
  {
    grid_bg = new Base(Constants.GRID_X, Constants.GRID_Y);
    grid_bg.graphic = new TiledImage(Assets.get("space_void"), 512, 384);
    grid_bg.layer = Constants.GRID_BG_LAYER;
    grid_bg.type = "grid_bg";
    grid_bg.updateHitbox();
  }

  public function setOffset(x:Int, y:Int)
  {
    offsetX = x;
    offsetY = y;
    each(function(s:Space, x:Int, y:Int):Void {
      s.graphic.x = offsetX;
      s.graphic.y = offsetY;
    });
    setVisibility();
  }

  public function setVisibility() {
    each(function(s:Space, x:Int, y:Int):Void {
      if(s.graphic.x + s.x > grid_bg.x + 512) {
        s.graphic.visible = false;
      } else if(s.graphic.y + s.y > grid_bg.y + 384) {
        s.graphic.visible = false;
      } else if(s.graphic.y + s.y < grid_bg.y - 100) {
        s.graphic.visible = false;
      } else if(s.graphic.x + s.x < grid_bg.x - 100) {
        s.graphic.visible = false;
      } else {
        s.graphic.visible = true;
      }
    });
  }

  public function finishDrag()
  {
    offsetX = 0;
    offsetY = 0;

    each(function(s:Space, x:Int, y:Int):Void {
      s.x = s.x + s.graphic.x;
      s.y = s.y + s.graphic.y;
      s.graphic.x = 0;
      s.graphic.y = 0;
    });
    setVisibility();
  }

}
