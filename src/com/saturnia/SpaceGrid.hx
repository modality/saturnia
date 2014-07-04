package com.saturnia;

import flash.geom.Point;
import com.modality.ElasticGrid;
import com.haxepunk.graphics.TiledImage;
import com.modality.Base;
import com.modality.Controller;

typedef Explorable = {
  var marker:Base;
  var x:Int;
  var y:Int;
  var valid:Bool;
}

class SpaceGrid extends ElasticGrid<Space>
{
  public var scene:Controller;
  public var GRID_BG_W:Int = 512;
  public var GRID_BG_H:Int = 384;
  public var grid_bg:Base;
  public var absoluteX:Float = 0;
  public var absoluteY:Float = 0;
  public var offsetX:Float = 0;
  public var offsetY:Float = 0;

  public var explorable:Array<Explorable>;

  public function new(_scene:Controller)
  {
    super();
    this.scene = _scene;
    explorable = [];

    grid_bg = new Base(Constants.GRID_X, Constants.GRID_Y);
    grid_bg.graphic = new TiledImage(Assets.get("space_void"), GRID_BG_W, GRID_BG_H);
    grid_bg.layer = Constants.GRID_BG_LAYER;
    grid_bg.type = "grid_bg";
    grid_bg.updateHitbox();

    var space = new Space();
    space.explore(Generator.randomSpaceStation());
    scene.add(space);
    add(0, 0, space);
    findExplorables();
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

  public function explore(marker:Base, spaceType:SpaceType):Point
  {
    for(e in explorable) {
      if(e.marker == marker) {
        var space = new Space();
        space.explore(spaceType);
        scene.add(space);
        add(e.x, e.y, space);
        findExplorables();
        centerOn(e.x, e.y);
        return new Point(e.x, e.y);
      }
    }
    return null;
  }

  public function centerOn(x:Int, y:Int)
  {
    absoluteX = (GRID_BG_W - Constants.BLOCK_W)/2 - x*Constants.BLOCK_W;
    absoluteY = (GRID_BG_H - Constants.BLOCK_H)/2 - y*Constants.BLOCK_H;
    finishDrag();
  }

  public function findExplorables()
  {
    var candidates:Map<Point, Bool> = new Map<Point, Bool>();
    var cKey = function(point:Point) {
      for(p in candidates.keys()) {
        if(p.equals(point)) return p;
      }
      return null;
    }

    each(function(s:Space, x:Int, y:Int):Void {
      var c = new Point(x, y),
          n = new Point(x, y-1),
          s = new Point(x, y+1),
          e = new Point(x+1, y),
          w = new Point(x-1, y);

      if(cKey(c) != null) {
        candidates.set(cKey(c), false);
      } else {
        candidates.set(c, false);
      }
      if(cKey(n) == null) candidates.set(n, true);
      if(cKey(s) == null) candidates.set(s, true);
      if(cKey(e) == null) candidates.set(e, true);
      if(cKey(w) == null) candidates.set(w, true);
    });

    for(spot in explorable) {
      var key = cKey(new Point(spot.x, spot.y));
      if(key != null && candidates.get(key)) {
        spot.valid = true;
        candidates.remove(key);
      } else {
        spot.valid = false;
      }
    }

    explorable = Lambda.array(Lambda.filter(explorable, function(e) {
      if(!e.valid) {
        scene.remove(e.marker);
      }
      return e.valid;
    }));

    for(point in candidates.keys()) {
      if(candidates.get(point)) {
        var marker:Base = new Base(0, 0, Assets.getSprite("tile_tex", 0, 0, 100, 100));
        marker.layer = Constants.UNEXPLORED_LAYER;
        marker.type = "explorable";
        marker.updateHitbox();
        scene.add(marker);
        explorable.push({
          x: Std.int(point.x),
          y: Std.int(point.y),
          valid: true,
          marker: marker
        });
      }
    }
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
    eachWithMarkers(function(b:Base, x:Int, y:Int) {
      if(b.graphic.x + b.x > grid_bg.x + 512) {
        b.graphic.visible = false;
      } else if(b.graphic.y + b.y > grid_bg.y + 384) {
        b.graphic.visible = false;
      } else if(b.graphic.y + b.y < grid_bg.y - 100) {
        b.graphic.visible = false;
      } else if(b.graphic.x + b.x < grid_bg.x - 100) {
        b.graphic.visible = false;
      } else {
        b.graphic.visible = true;
      }
    });
  }

  private function eachWithMarkers(fn:Base->Int->Int->Void) {
    each(fn);
    for(spot in explorable) {
      fn(spot.marker, spot.x, spot.y);
    }
  }

}
