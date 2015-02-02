package com.saturnia.ui;

import openfl.display.BitmapData;
import openfl.events.Event;
import com.haxepunk.graphics.Image;
import com.modality.Base;
import com.modality.TextBase;

class PowerMenuItem extends Base
{
  public static var CLICKED:String = "clicked item";

  public var selector:Base;
  public var text:TextBase;
  public var costText:TextBase;
  public var energyIcon:Base;

  public function new(_x:Int, _y:Int, _text:String, _cost:Int)
  {
    var bmd:BitmapData = new BitmapData(1, 1, false, Constants.ENERGY_COLOR);
    var img = new Image(bmd);
    img.scaleX = 50;
    img.scaleY = 40;
    img.x = 5;
    img.y = 5;

    super(_x, _y, img);

    text = new TextBase(5, 18, 50, 50, _text);
    text.color = 0x000000;
    text.align = "center";
    costText = new TextBase(0, 52, 35, 20, ""+_cost);
    costText.align = "right";
    energyIcon = new Base(35, 50, Assets.getImage("icon_energy"));
    selector = new Base(0, 0, Assets.getImage("icon_selector"));
    selector.alpha = 0;

    addChild(text);
    addChild(costText);
    addChild(energyIcon);
    addChild(selector);

    type = "power_menu_item";

    updateHitbox();
    addEventListener(CLICKED, onClick);

    eachChild(function(child:Base):Void {
      child.updateHitbox();
      child.type = type;
      child.addEventListener(CLICKED, onClick);
    });
  }

  public function onClick(event:Dynamic):Void
  {
  }
}

