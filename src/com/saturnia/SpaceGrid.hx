package com.saturnia;

import flash.geom.Point;
import com.modality.ElasticGrid;
import com.modality.Base;
import com.modality.Controller;

class SpaceGrid extends ElasticGrid<Space>
{
  public var scene:Controller;
  public var grid_bg:Base;
  public var absoluteX:Float = 0;
  public var absoluteY:Float = 0;
  public var offsetX:Float = 0;
  public var offsetY:Float = 0;

  public function new(_scene:Controller)
  {
    super();
    this.scene = _scene;

    grid_bg = new Base(Constants.GRID_X, Constants.GRID_Y);
    grid_bg.graphic = Assets.getImage("nebula_bg_"+(Math.floor(Math.random() * 5)+1));
    grid_bg.layer = Constants.GRID_BG_LAYER;
    grid_bg.type = "grid_bg";
    grid_bg.updateHitbox();

    var space = new Space();
    space.explore(Generator.randomSpaceStation());
    scene.add(space);
    add(0, 0, space);
    centerOn(0, 0);
  }

  public override function add(i:Int, j:Int, space:Space)
  {
    super.add(i, j, space);
    space.grid = this;
    space.x = Constants.GRID_X+(i*Constants.BLOCK_W) + offsetX;
    space.y = Constants.GRID_Y+(j*Constants.BLOCK_H) + offsetY;
    space.updateGraphic();
  }

  public function centerOn(x:Int, y:Int)
  {
    absoluteX = (Constants.GRID_W - Constants.BLOCK_W)/2 - x*Constants.BLOCK_W;
    absoluteY = (Constants.GRID_H - Constants.BLOCK_H)/2 - y*Constants.BLOCK_H;
    finishDrag();
  }

  public function setOffset(x:Float, y:Float)
  {
    offsetX = x;
    offsetY = y;
    eachWithMarkers(function(b:Base, x:Int, y:Int):Void {
      b.graphic.x = offsetX;
      b.graphic.y = offsetY;
    });

    setVisibility();
  }

  public function finishDrag()
  {
    absoluteX += offsetX;
    absoluteY += offsetY;

    offsetX = 0;
    offsetY = 0;

    eachWithMarkers(function(b:Base, x:Int, y:Int) {
      b.graphic.x = 0;
      b.graphic.y = 0;
      b.x = Constants.GRID_X + (x*Constants.BLOCK_W) + absoluteX;
      b.y = Constants.GRID_Y + (y*Constants.BLOCK_H) + absoluteY;
    });
 
    setVisibility();
  }

  public function setVisibility() {
    each(function(b:Base, x:Int, y:Int) {
      if(b.graphic.x + b.x > grid_bg.x + Constants.GRID_W) {
        b.graphic.visible = false;
      } else if(b.graphic.y + b.y > grid_bg.y + Constants.GRID_H) {
        b.graphic.visible = false;
      } else if(b.graphic.y + b.y < grid_bg.y - Constants.BLOCK_H) {
        b.graphic.visible = false;
      } else if(b.graphic.x + b.x < grid_bg.x - Constants.BLOCK_W) {
        b.graphic.visible = false;
      } else {
        b.graphic.visible = true;
      }
    });
  }

}
