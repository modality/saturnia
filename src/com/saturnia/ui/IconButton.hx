package com.saturnia.ui;

import openfl.display.BitmapData;
import com.haxepunk.graphics.Image;
import com.modality.Base;
import com.modality.TextBase;

class IconButton extends Base
{
  public var w:Int;
  public var h:Int;

  public var text:TextBase;
  public var icon:Base;

  public var imageOff:Image;
  public var imageOn:Image;

  public function new(_x:Float, _y:Float, _w:Int, _h:Int, _text:String, _icon:String)
  {
    super(_x, _y);
    w = _w;
    h = _h;

    imageOff = new Image(new BitmapData(w, h, false, 0x444444));
    imageOn = new Image(new BitmapData(w, h, false, 0x888888));
    graphic = imageOff;

    text = new TextBase(0, 0, w, h, _text);
    icon = new Base(0, 0, Assets.getImage("icon_"+_icon));

    text.x = (w - text.textObj.textWidth - 5 - cast(icon.graphic, Image).width)/2.;
    text.y = (h - text.textObj.textHeight)/2.;

    icon.x = text.x + text.textObj.textWidth + 5;
    icon.y = (h - cast(icon.graphic, Image).height)/2.;

    addChild(text);
    addChild(icon);
  }

}
