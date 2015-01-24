package com.saturnia.ui;

import openfl.events.Event;
import com.modality.Base;
import com.modality.TextBase;

class MerchantMenuItem extends TextBase
{
  public static var REMOVED:String = "removed item";
  public static var CLICKED:String = "clicked item";

  public var shipPart:ShipPart;

  public var buyText:TextBase;
  public var cargoCost:TextBase;
  public var cargoIcon:Base;
  public var scienceCost:TextBase;
  public var scienceIcon:Base;

  public function new(_x:Int, _y:Int, _shipPart:ShipPart)
  {
    super(_x, _y, 50, 20, _shipPart.name);
    shipPart = _shipPart;
    type = "merchant_menu_parent";

    var tb:TextBase;

    if(shipPart.scienceCost > 0) {
      tb = new TextBase(225, 0, 30, 10, ""+shipPart.scienceCost);
      tb.color = Constants.SCIENCE_COLOR;
      addChild(tb);
      addChild(new Base(200, -1, Assets.getImage("icon_science")));
    } else if (shipPart.cargoCost > 0) {
      tb = new TextBase(225, 0, 30, 10, ""+shipPart.cargoCost);
      tb.color = Constants.CARGO_COLOR;
      addChild(tb);
      addChild(new Base(200, -1, Assets.getImage("icon_cargo")));
    }
    addChild(new TextBase(270, 0, 10, 10, "BUY"));

    tb = new TextBase(0, 25, 100, 20, shipPart.description);
    tb.size = Constants.FONT_SIZE_XS;
    addChild(tb);

    eachChild(function(child:Base):Void {
      child.updateHitbox();
      child.type = "merchant_menu_item";
      child.addEventListener(CLICKED, onClick);
    });

    shipPart.addEventListener(ShipPartEvent.PURCHASED, onRemove);
  }

  public function onClick(?event:Event):Void
  {
    dispatchEvent(new ShipPartEvent(CLICKED, shipPart));
  }

  public function onRemove(?event:Event):Void
  {
    dispatchEvent(new Event(REMOVED));
  }
}
