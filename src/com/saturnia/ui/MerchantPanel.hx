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
    panel.updateGraphic();
  }
}
