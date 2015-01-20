package com.saturnia.ui;

import openfl.display.BitmapData;
import com.haxepunk.graphics.Image;
import com.modality.Base;

class ProgressBar extends Base
{
  public var w:Int;
  public var h:Int;

  public function new(_x:Float, _y:Float, _w:Int, _h:Int, _color:Int)
  {
    super(_x, _y);
    w = _w;
    h = _h;

    var bmd:BitmapData = new BitmapData(1, 1, false, _color);
    var img:Image;
    img = new Image(bmd);
    img.scaleX = w;
    img.scaleY = h;
    graphic = img;
  }

  public function set(_percent:Float)
  {
    image.scaleX = Math.ceil(_percent * w);
  }
}
