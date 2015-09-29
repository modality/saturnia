package com.saturnia.ui;

import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;

class NavigationPanel extends Base
{
  public var galaxy:Galaxy;
  public var go_btn:TextBase;
  public var cancel_btn:TextBase;
  public var sector_name:TextBase;
  public var sector_type:TextBase;

  public function new(_galaxy:Galaxy)
  {
    super(50, 50);
    galaxy = _galaxy;

    var modal = Assets.getImage("ui_modal");
    modal.scaleX = 700;
    modal.scaleY = 500;
    this.graphic = modal;
    this.layer = Constants.OVERLAY_LAYER;

    var tb:TextBase;

    tb = new TextBase(10, 20, 300, 50, "Navigation");
    tb.size = Constants.FONT_SIZE_MD;
    addChild(tb);
    
    addChild(new TextBase(10, 225, 50, 50, "X:"));
    addChild(new TextBase(160, 225, 50, 50, "Y:"));

    sector_name = new TextBase(10, 375, 50, 50, "Sector Name:");
    sector_type = new TextBase(10, 400, 50, 50, "Sector Type:");
    addChild(sector_name);
    addChild(sector_type);

    cancel_btn = new TextBase(200, 450, 50, 50, "CANCEL");
    cancel_btn.type = "cancel_btn";
    cancel_btn.size = Constants.FONT_SIZE_MD;

    go_btn = new TextBase(100, 450, 50, 50, "GO");
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

      btn = cast(scene.collidePoint("go_btn", Input.mouseX, Input.mouseY), TextBase);
      if(btn != null) {
      }
    }
  }

  public function relayout()
  {
    sector_name.text = "Sector Name: ";
    sector_type.text = "Sector Type: ";
  }

}
