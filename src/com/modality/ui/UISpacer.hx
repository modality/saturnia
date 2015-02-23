package com.modality.ui;

import openfl.display.BitmapData;
import com.haxepunk.graphics.Image;

class UISpacer extends UIElement
{
  public var w:Int;
  public var h:Int;

  public function new(_w:Int, _h:Int, _line:Bool = false, _lineColor:Int = 0xFFFFFF)
  {
    w = _w;
    h = _h;

    if(_line) {
      var img = new Image(new BitmapData(w, 1, false, _lineColor));
      entity = new Base(0, h, img);
    } else {
      entity = new Base(0, 0);
    }
  }

  public override function width():Float
  {
    return w;
  }
  public override function height():Float
  {
    return h;
  }

  public override function updateGraphic():Void
  {
    entity.y += h/2;
  }
}
