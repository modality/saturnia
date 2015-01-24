package com.saturnia.ui;

import openfl.events.Event;
import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;

class MerchantPanel extends Base
{
  public var merchant:MerchantEncounter;
  public var player:PlayerResources;

  public var ok_btn:TextBase;
  public var sellGood:GoodsMenuItem;
  public var buyGood:GoodsMenuItem;

  public function new(_space:Space, _player:PlayerResources)
  {
    super(50, 50);

    merchant = cast(_space.encounter, MerchantEncounter);
    player = _player;

    var modal = Assets.getImage("ui_modal");
    modal.scaleX = 700;
    modal.scaleY = 500;
    this.graphic = modal;
    this.layer = Constants.OVERLAY_LAYER;

    var tb:TextBase;

    tb = new TextBase(10, 20, 300, 50, "Ship Parts");
    tb.size = Constants.FONT_SIZE_MD;
    addChild(tb);

    tb = new TextBase(360, 20, 300, 50, "Trade Goods");
    tb.size = Constants.FONT_SIZE_MD;
    addChild(tb);

    var pos = 0;
    for(part in merchant.parts) {
      var mmi = new MerchantMenuItem(10, (50 * pos) + 50, part);
      mmi.addEventListener(MerchantMenuItem.CLICKED, clickedItem);
      mmi.addEventListener(MerchantMenuItem.REMOVED, removedItem);
      addChild(mmi);
      pos++;
    }


    sellGood = new GoodsMenuItem(360, 50,
                                 merchant.goodSold,
                                 merchant.goodInventory,
                                 merchant.sellRate,
                                 true);

    buyGood = new GoodsMenuItem(360, 100,
                                merchant.goodBought,
                                0,
                                merchant.buyRate,
                                false);

    addChild(sellGood);
    addChild(buyGood);

    ok_btn = new TextBase(140, 300, 50, 50, "OK");
    ok_btn.type = "ok_btn";
    ok_btn.size = Constants.FONT_SIZE_MD;
    addChild(ok_btn);
  }

  public override function update()
  {
    super.update();
    if(Input.mouseReleased) {
      var base:Base = cast(scene.collidePoint("merchant_menu_item", Input.mouseX, Input.mouseY), Base);
      if(base != null) {
        base.dispatchEvent(new Event(MerchantMenuItem.CLICKED));
      }

      var base:Base = cast(scene.collidePoint("merchant_menu_parent", Input.mouseX, Input.mouseY), Base);
      if(base != null) {
        cast(base, MerchantMenuItem).onClick();
      }

      var btn:TextBase = cast(scene.collidePoint("ok_btn", Input.mouseX, Input.mouseY), TextBase);
      if(btn != null) {
        cast(scene, GameController).exitMerchant();
      }
    }
  }

  public function clickedItem(event:ShipPartEvent):Void
  {
    if(player.buyShipPart(event.shipPart)) {
      merchant.boughtPart(event.shipPart);
    }
  }

  public function removedItem(event:Event):Void
  {
    var menuItem = cast(event.currentTarget, MerchantMenuItem);
    removeChild(menuItem);
  }
}
