package com.saturnia.ui;

import openfl.display.BitmapData;

import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.modality.Base;
import com.modality.TextBase;

class PopupIcon extends Base
{
  var popup:Base;
  var text:TextBase;

  public function new(_x:Float, _y:Float, _text:String)
  {
    super(_x, _y);
    var id = new Identicon();
    var img = new Image(id.bmd);
    type = "popup_icon";
    layer = Constants.RESOURCE_LAYER;
    img.scaleX = 5;
    img.scaleY = 5;
    graphic = img;

    text = new TextBase(3, 3, 0, 0, _text);
    text.size = Constants.FONT_SIZE_XS;

    var bmd = new BitmapData(text.textObj.textWidth + 6, text.textObj.textHeight + 6, false, 0x000000);
    for(i in 0...bmd.width) {
      bmd.setPixel(i, 0, 0xFFFFFF);
      bmd.setPixel(i, bmd.height-1, 0xFFFFFF);
    }

    for(j in 0...bmd.height) {
      bmd.setPixel(0, j, 0xFFFFFF);
      bmd.setPixel(bmd.width-1, j, 0xFFFFFF);
    }

    setHitbox(25, 25);
    popup = new Base(30, 0, new Image(bmd));
    popup.addChild(text);
    addChild(popup);

    popup.alpha = 0;
    text.alpha = 0;
  }

  public override function update()
  {
    super.update();
    if(collidePoint(x, y, Input.mouseX, Input.mouseY)) {
      popup.alpha = 1;
      text.alpha = 1;
    } else {
      popup.alpha = 0;
      text.alpha = 0;
    }
  }
}

