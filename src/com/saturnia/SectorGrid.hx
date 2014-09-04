package com.saturnia;

import com.modality.ElasticGrid;

typedef Explorable = {
  var marker:Base;
  var x:Int;
  var y:Int;
  var valid:Bool;
}

class SectorGrid extends ElasticGrid<Sector>
{
  public var explorable:Array<Explorable>;
  public var spaceGrid:SpaceGrid;

  public function new(_sg:SpaceGrid)
  {
    super();
    explorable = [];

    findExplorables();
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
        //centerOn(e.x, e.y);
        finishDrag();
        return new Point(e.x, e.y);
      }
    }
    return null;
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
        var marker:Base = new Base(0, 0, Assets.getSprite("tile_tex", 0, 0, Constants.BLOCK_W, Constants.BLOCK_H));
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


}
