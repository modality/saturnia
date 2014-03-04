package com.saturnia;

import flash.events.Event;
import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;

class MerchantPanel extends Base
{
  public var space:Space;
  public var player:PlayerResources;

  public var ok_btn:TextBase;

  public function new(_space:Space, _player:PlayerResources)
  {
    super();

    space = _space;
    player = _player;

    var modal = Assets.getImage("ui_modal");
    modal.scaleX = 320;
    modal.scaleY = 480;
    this.graphic = modal;
    this.layer = Constants.OVERLAY_LAYER;

    var pos = 0;
    for(good in cast(space.encounter, MerchantEncounter).goods) {
      var mmi = new MerchantMenuItem(10, (50 * pos) + 50, good);
      mmi.addEventListener(MerchantMenuItem.CLICKED, clickedItem);
      mmi.addEventListener(MerchantMenuItem.REMOVED, removedItem);
      addChild(mmi);
      pos++;
    }

    ok_btn = new TextBase(140, 300, "OK");
    ok_btn.type = "ok_btn";
    ok_btn.size = Constants.FONT_SIZE_MD;
    ok_btn.layer = Constants.OVERLAY_LAYER;
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

      var btn:TextBase = cast(scene.collidePoint("ok_btn", Input.mouseX, Input.mouseY), TextBase);
      if(btn != null) {
        cast(scene, GameController).exitMerchant(space, true);
      }
    }
  }

  public function clickedItem(event:Dynamic):Void
  {
    var menuItem = cast(cast(event, Event).currentTarget, MerchantMenuItem);
    var item:Item = menuItem.item;

    player.buyItem(item);
  }

  public function removedItem(event:Dynamic):Void
  {
    var menuItem = cast(cast(event, Event).currentTarget, MerchantMenuItem);
    removeChild(menuItem);
  }
}
