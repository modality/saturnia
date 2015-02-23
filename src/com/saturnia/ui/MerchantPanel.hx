package com.saturnia.ui;

import openfl.events.Event;
import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;
import com.modality.ui.UIPanel;
import com.modality.ui.UIAlign;
import com.modality.ui.UILabel;

class MerchantPanel extends Base
{
  public var friendly:FriendlyEncounter;
  public var player:PlayerResources;

  public var ok_btn:TextBase;
  public var sellGood:GoodsMenuItem;
  public var buyGood:GoodsMenuItem;

  public var panel:UIPanel;

  public function new(_space:Space, _player:PlayerResources)
  {
    super(50, 50);

    friendly = cast(_space.encounter, FriendlyEncounter);
    player = _player;

    var modal = Assets.getImage("ui_modal");
    modal.scaleX = 700;
    modal.scaleY = 500;
    this.graphic = modal;
    this.layer = Constants.OVERLAY_LAYER;

    panel = new UIPanel(20, 20, 660, 460);
    addChild(panel.entity);

    panel.addChild(new UILabel("Ship Parts", Constants.FONT_SIZE_MD), UIAlign.Left);
    panel.addChild(new UILabel("Trade Goods", Constants.FONT_SIZE_MD), UIAlign.Left);

    var pos = 0;
    for(item in friendly.items) {
      var mmi = new MerchantMenuItem(10, (50 * pos) + 50, item);
      mmi.addEventListener(MerchantMenuItem.CLICKED, clickedItem);
      mmi.addEventListener(MerchantMenuItem.REMOVED, removedItem);
      addChild(mmi);
      pos++;
    }

    panel.updateGraphic();

    /*
    sellGood = new GoodsMenuItem(360, 50,
                                 friendly.goodSold,
                                 friendly.goodInventory,
                                 friendly.sellRate,
                                 true);

    buyGood = new GoodsMenuItem(360, 100,
                                friendly.goodBought,
                                0,
                                friendly.buyRate,
                                false);

    addChild(sellGood);
    addChild(buyGood);
    */

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
    /*
    if(player.buyShipPart(event.shipPart)) {
      friendly.boughtPart(event.shipPart);
    }
    */
  }

  public function removedItem(event:Event):Void
  {
    var menuItem = cast(event.currentTarget, MerchantMenuItem);
    removeChild(menuItem);
  }
}
