package com.saturnia.ui;

import openfl.events.Event;
import com.modality.Base;
import com.modality.TextBase;

class ShipPartMenuItem extends Base
{
  public static var CLICKED:String = "clicked item";

  public var shipPart:ShipPart;
  public var text:TextBase;

  public function new(_x:Int, _y:Int, _shipPart:ShipPart)
  {
    var img = Assets.getImage("icon_gear");
    img.scaleX = 0.1;
    img.scaleY = 0.1;
    super(_x, _y, img);
    shipPart = _shipPart;
    type = "ship_part_menu_item";

    shipPart.addEventListener(ShipPart.UPDATED, updateText);

    text = new TextBase(20, 0, 50, 20, shipPart.name);
    addChild(text);
    updateText();

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
    dispatchEvent(new ShipPartEvent(ShipPartEvent.TRY_USE, shipPart));
  }

  public function updateText(?event:Dynamic):Void
  {
    text.text = shipPart.name;
  }
}
