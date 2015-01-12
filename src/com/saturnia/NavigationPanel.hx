package com.saturnia;

import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;

class NavigationPanel extends Base
{
  public var player:PlayerResources;

  public var go_btn:TextBase;
  public var cancel_btn:TextBase;

  public function new(_player:PlayerResources)
  {
    super(50, 50);
    player = _player;

    var modal = Assets.getImage("ui_modal");
    modal.scaleX = 700;
    modal.scaleY = 500;
    this.graphic = modal;
    this.layer = Constants.OVERLAY_LAYER;

    var tb:TextBase;

    tb = new TextBase(10, 20, 300, 50, "Navigation");
    tb.size = Constants.FONT_SIZE_MD;
    addChild(tb);

    cancel_btn = new TextBase(200, 300, 50, 50, "CANCEL");
    cancel_btn.type = "cancel_btn";
    cancel_btn.size = Constants.FONT_SIZE_MD;

    go_btn = new TextBase(100, 300, 50, 50, "GO");
    go_btn.type = "go_btn";
    go_btn.size = Constants.FONT_SIZE_MD;

    addChild(go_btn);
    addChild(cancel_btn);
  }

  public override function update()
  {
    super.update();
    if(Input.mouseReleased) {
      var btn:TextBase;

      btn = cast(scene.collidePoint("cancel_btn", Input.mouseX, Input.mouseY), TextBase);
      if(btn != null) {
        cast(scene, GameController).exitNavigation();
      }
    }
  }

}
