package com.saturnia;

import flash.events.Event;
import com.modality.Base;
import com.modality.TextBase;

class MerchantMenuItem extends TextBase
{
  public static var REMOVED:String = "removed item";
  public static var CLICKED:String = "clicked item";

  public var item:Item;

  public var buyText:TextBase;
  public var cargoCost:TextBase;
  public var cargoIcon:Base;
  public var scienceCost:TextBase;
  public var scienceIcon:Base;

  public function new(_x:Int, _y:Int, _item:Item)
  {
    super(_x, _y, 50, 20, _item.name);
    item = _item;
    type = "merchant_menu_item";

    var tb:TextBase;

    if(item.scienceCost > 0) {
      tb = new TextBase(225, 0, 30, 10, ""+item.scienceCost);
      tb.color = Constants.SCIENCE_COLOR;
      addChild(tb);
      addChild(new Base(200, -1, Assets.getImage("icon_science")));
    } else if (item.cargoCost > 0) {
      tb = new TextBase(225, 0, 30, 10, ""+item.cargoCost);
      tb.color = Constants.CARGO_COLOR;
      addChild(tb);
      addChild(new Base(200, -1, Assets.getImage("icon_cargo")));
    }
    addChild(new TextBase(270, 0, 10, 10, "BUY"));

    tb = new TextBase(0, 25, 100, 20, item.description);
    tb.size = Constants.FONT_SIZE_XS;
    addChild(tb);

    eachChild(function(child:Base):Void {
      child.updateHitbox();
      child.type = "merchant_menu_item";
      child.addEventListener(CLICKED, onClick);
    });

    item.addEventListener(Item.PURCHASED, onRemove);
  }

  public function onClick(event:Dynamic):Void
  {
    dispatchEvent(new Event(CLICKED));
  }

  public function onRemove(even:Dynamic):Void
  {
    dispatchEvent(new Event(REMOVED));
  }
}
