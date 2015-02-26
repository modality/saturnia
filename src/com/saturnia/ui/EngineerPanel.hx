package com.saturnia.ui;

import com.modality.Base;
import com.modality.TextBase;
import com.modality.ui.UIPanel;
import com.modality.ui.UIAlign;
import com.modality.ui.UILabel;
import com.modality.ui.UIButton;
import com.modality.ui.UISpacer;
import com.modality.AugRandom;

class EngineerPanel extends Base
{
  public var encounter:EngineerEncounter;
  public var galaxy:Galaxy;

  public var panel:UIPanel;
  public var leftPanel:UIPanel;
  public var rightPanel:UIPanel;

  public var contractLength:Int;
  public var contractPrice:Int;

  public function new(_space:Space, _galaxy:Galaxy)
  {
    super(50, 50);

    //encounter = cast(_space.encounter, EngineerPanel);
    galaxy = _galaxy;

    var modal = Assets.getImage("ui_modal");
    modal.scaleX = 700;
    modal.scaleY = 500;
    this.graphic = modal;
    this.layer = Constants.OVERLAY_LAYER;

    panel = new UIPanel(20, 20, 660, 460);
    leftPanel = new UIPanel(0, 0, 300, 0);
    rightPanel = new UIPanel(0, 0, 300, 0);

    panel.addChild(new UILabel("Marble Heavy Industries", Constants.FONT_SIZE_LG), UIAlign.Left);
    panel.addChild(new UISpacer(660, 20), UIAlign.Left);
    panel.addChild(new UILabel(""), UIAlign.FloatLeft);
    panel.addChild(new UILabel(""), UIAlign.FloatRight);
    panel.addChild(new UILabel(""), UIAlign.Center);
    panel.addChild(new UISpacer(660, 40, true), UIAlign.Left);

    panel.addChild(rightPanel, UIAlign.FloatRight);
    panel.addChild(leftPanel, UIAlign.Left);

    panel.addChild(new UISpacer(660, 40, true), UIAlign.Left);
    panel.addChild(new UIButton(150, 50, "CLOSE", closePanel), UIAlign.Center);

    addChild(panel.entity);

    panel.updateGraphic();
  }

  public function closePanel(button:UIButton):Void
  {
    cast(scene, GameController).exitMerchant();
  }

  public override function update()
  {
    super.update();
    panel.update();
  }
}



