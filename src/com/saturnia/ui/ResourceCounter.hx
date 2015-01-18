package com.saturnia.ui;

import com.haxepunk.graphics.Image;
import com.modality.Base;
import com.modality.TextBase;

class ResourceCounter extends Base
{
  public var text:TextBase;

  public var amount:Int;

  public function new(_x:Float, _y:Float, icon:String)
  {
    super(_x, _y, Assets.getImage("icon_"+icon));
    layer = Constants.RESOURCE_LAYER;

    text = new TextBase(25, 1, 100, 20, "");
    text.color = 0xFFFFFF;
    addChild(text);
  }

  public function set(_amount:Int, _maximum:Int = 0)
  {
    amount = _amount;
    text.text = ""+amount;
  }

}

