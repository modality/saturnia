package com.saturnia.ui;

import openfl.display.BitmapData;
import com.haxepunk.graphics.Image;
import com.modality.Base;
import com.modality.TextBase;

class ResourceBar extends ResourceCounter
{
  public static var BAR_WIDTH:Int = 275;
  public static var BAR_HEIGHT:Int = 20;

  public var topBar:Base;
  public var bottomBar:Base;

  public var maximum:Int;

  public function new(_x:Float, _y:Float, icon:String, color:Int)
  {
    super(_x, _y, icon);

    var bmd:BitmapData = new BitmapData(1, 1, false, color);
    var img:Image;

    img = new Image(bmd);
    img.scaleX = BAR_WIDTH;
    img.scaleY = BAR_HEIGHT;
    topBar = new Base(25, 0, img);

    img = new Image(bmd);
    img.alpha = 0.7;
    img.scaleX = BAR_WIDTH;
    img.scaleY = BAR_HEIGHT;
    bottomBar = new Base(25, 0, img);

    addChild(bottomBar);
    addChild(topBar);
    removeChild(text);
    addChild(text);
  }

  public function preview(_amount:Int)
  {
    text.text = _amount+"/"+maximum;
    cast(topBar.graphic, Image).scaleX = Math.ceil(BAR_WIDTH * _amount / maximum);
  }

  public override function set(_amount:Int, _maximum:Int = 0)
  {
    amount = _amount;
    maximum = _maximum;
    reset();
  }

  public function reset()
  {
    text.text = amount+"/"+maximum;
    if(maximum != 0) {
      cast(topBar.graphic, Image).scaleX = Math.ceil(BAR_WIDTH * amount / maximum);
      cast(bottomBar.graphic, Image).scaleX = Math.ceil(BAR_WIDTH * amount / maximum); 
    } else {
      cast(topBar.graphic, Image).scaleX = BAR_WIDTH;
      cast(bottomBar.graphic, Image).scaleX = BAR_WIDTH;
    }
  }
}
