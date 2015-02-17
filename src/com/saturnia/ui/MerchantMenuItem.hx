package com.saturnia.ui;

import openfl.events.Event;
import com.modality.Base;
import com.modality.TextBase;

class MerchantMenuItem extends TextBase
{
  public static var REMOVED:String = "removed item";
  public static var CLICKED:String = "clicked item";

  public var purchasable:Purchasable;

  public var buyButton:IconButton;

  public function new(_x:Int, _y:Int, _purchasable:Purchasable)
  {
    super(_x, _y, 50, 20, _purchasable.displayName());
    purchasable = _purchasable;
    type = "merchant_menu_parent";

    var tb:TextBase;

    if(purchasable.scienceCost > 0) {
      buyButton = new IconButton(200, 0, 80, 40, ""+purchasable.scienceCost, "science");
    } else if (purchasable.cargoCost > 0) {
      buyButton = new IconButton(200, 0, 80, 40, ""+purchasable.cargoCost, "cargo");
    }

    addChild(buyButton);

    tb = new TextBase(0, 25, 180, 20, purchasable.displayDescription());
    tb.size = Constants.FONT_SIZE_XS;
    addChild(tb);

    /*
    eachChild(function(child:Base):Void {
      child.updateHitbox();
      child.type = "merchant_menu_item";
      child.addEventListener(CLICKED, onClick);
    });

    purchasable.addEventListener(ShipPartEvent.PURCHASED, onRemove);
    */
  }

  public function onClick(?event:Event):Void
  {
    //dispatchEvent(new ShipPartEvent(CLICKED, shipPart));
  }
}
