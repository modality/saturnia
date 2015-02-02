package com.saturnia.ui;

import openfl.display.BitmapData;
import com.haxepunk.graphics.Image;
import com.modality.Base;
import com.modality.TextBase;

class ResourceBar extends ResourceCounter
{
  public var topBar:ProgressBar;
  public var bottomBar:ProgressBar;

  public var maximum:Int;

  public function new(_x:Float, _y:Float, _w:Int = 275, _h:Int = 20, icon:String, color:Int)
  {
    super(_x, _y, icon);

    topBar = new ProgressBar(25, 0, _w, _h, color);
    bottomBar = new ProgressBar(25, 0, _w, _h, color);
    bottomBar.image.alpha = 0.7;

    addChild(bottomBar);
    addChild(topBar);
    removeChild(text);
    addChild(text);
  }

  public function preview(_amount:Int)
  {
    text.text = _amount+"/"+maximum;
    topBar.set(_amount/maximum);
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
      topBar.set(amount/maximum);
      bottomBar.set(amount/maximum);
    } else {
      topBar.set(1);
      bottomBar.set(1);
    }
  }
}
