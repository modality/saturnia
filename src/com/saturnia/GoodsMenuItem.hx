package com.saturnia;

import flash.events.Event;
import com.modality.Base;
import com.modality.TextBase;

class GoodsMenuItem extends TextBase
{
  public static var CLICKED:String = "clicked item";

  public var goodPrice:TextBase;

  public function new(_x:Int, _y:Int, title:String, count:Int, price:Int, seller:Bool)
  {
    if(seller) title = title + " ("+count+")";
    super(_x, _y, 50, 0, title);
    type = "goods_menu_item";

    addChild(new TextBase(225, 0, 30, 10, ""+price+"/-"));
    addChild(new Base(200, -1, Assets.getImage("icon_cargo")));
    addChild(new TextBase(270, 0, 10, 10, (seller ? "BUY" : "SELL")));

    eachChild(function(child:Base):Void {
      child.updateHitbox();
      child.type = "goods_menu_item";
      child.addEventListener(CLICKED, onClick);
    });
  }

  public function onClick(event:Dynamic):Void
  {
    dispatchEvent(new Event(CLICKED));
  }
}

