package com.saturnia.ui;

import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;
import com.modality.ui.UIPanel;
import com.modality.ui.UIAlign;
import com.modality.ui.UILabel;
import com.modality.ui.UIButton;
import com.modality.ui.UISpacer;

class MerchantPanel extends Base
{
  public var encounter:MerchantEncounter;
  public var galaxy:Galaxy;

  public var panel:UIPanel;
  public var leftPanel:UIPanel;
  public var rightPanel:UIPanel;

  public function new(_space:Space, _galaxy:Galaxy)
  {
    super(50, 50);

    encounter = cast(_space.encounter, MerchantEncounter);
    galaxy = _galaxy;

    var modal = Assets.getImage("ui_modal");
    modal.scaleX = 700;
    modal.scaleY = 500;
    this.graphic = modal;
    this.layer = Constants.OVERLAY_LAYER;

    panel = new UIPanel(20, 20, 660, 460);
    leftPanel = new UIPanel(0, 0, 300, 0);
    rightPanel = new UIPanel(0, 0, 300, 0);

    panel.addChild(new UILabel("Rare Shipping", Constants.FONT_SIZE_LG), UIAlign.Left);
    panel.addChild(new UISpacer(660, 20), UIAlign.Left);
    panel.addNamedChild("good sold label", new UILabel(""), UIAlign.FloatLeft);
    panel.addNamedChild("fuel label", new UILabel(""), UIAlign.FloatCenter);
    panel.addChild(new UILabel("Wants "+encounter.goodBought.fullPlural()), UIAlign.Right);
    panel.addChild(new UISpacer(660, 40, true), UIAlign.Left);

    leftPanel.addChild(new UILabel("SussuruServe CN", Constants.FONT_SIZE_MD), UIAlign.Left);
    leftPanel.addChild(new UISpacer(300, 20), UIAlign.Left);

    rightPanel.addChild(new UILabel("Exchange Rates", Constants.FONT_SIZE_MD), UIAlign.Left);
    rightPanel.addNamedChild("player cargo text", new UILabel(""), UIAlign.Left);
    rightPanel.addChild(new UISpacer(300, 10), UIAlign.Left);

    rightPanel.addNamedChild("good label text", new UILabel(""), UIAlign.Left);
    rightPanel.addNamedChild("good sold text", new UIButton(300, 30, "", tradeGood(1)), UIAlign.Left);
    rightPanel.addChild(new UISpacer(300, 5), UIAlign.Left);
    rightPanel.addNamedChild("good sold text mass", new UIButton(300, 30, "", tradeGood(5)), UIAlign.Left);

    rightPanel.addChild(new UISpacer(300, 20), UIAlign.Left);

    rightPanel.addChild(new UILabel("1 "+encounter.goodBought.fullSingle()+" : 1 Fuel"), UIAlign.Left);
    rightPanel.addChild(new UIButton(300, 30, "Get 1 Fuel", tradeFuel(1)), UIAlign.Left);
    rightPanel.addChild(new UISpacer(300, 5), UIAlign.Left);
    rightPanel.addChild(new UIButton(300, 30, "Get 3 Fuel", tradeFuel(3)), UIAlign.Left);

    panel.addChild(leftPanel, UIAlign.FloatLeft);
    panel.addChild(rightPanel, UIAlign.Right);
    panel.addChild(new UISpacer(660, 40, true), UIAlign.Left);
    panel.addChild(new UIButton(150, 50, "CLOSE", closePanel), UIAlign.Center);

    addChild(panel.entity);

    updateLabels();
    panel.updateGraphic();
  }

  public function updateLabels():Void
  {
    var playerCargo = galaxy.player.cargos.get(encounter.goodBought);
    panel.getChild("good sold label").updateText('Has ${encounter.goodInventory} ${encounter.goodSold.fullPlural()}');
    panel.getChild("fuel label").updateText('Has ${encounter.fuelInventory} Fuel');
    rightPanel.getChild("player cargo text").updateText('You have ${playerCargo} ${encounter.goodBought.getFull(playerCargo)}');
    rightPanel.getChild("good label text").updateText('1 ${encounter.goodBought.fullSingle()} : ${encounter.goodRatio} ${encounter.goodSold.getFull(encounter.goodRatio)}');
    rightPanel.getChild("good sold text").updateText('Get ${encounter.goodRatio} ${encounter.goodSold.getShort(encounter.goodRatio)}');
    rightPanel.getChild("good sold text mass").updateText('Get ${5*encounter.goodRatio} ${encounter.goodSold.shortPlural()}');
  }

  public function tradeGood(ratio:Int):UIButton->Void
  {
    return function(button:UIButton):Void {
      if(galaxy.player.cargos.get(encounter.goodBought) >= ratio) {
        if(encounter.goodInventory >= ratio * encounter.goodRatio) {
          encounter.goodInventory -= ratio * encounter.goodRatio;
          galaxy.player.addCargo(encounter.goodBought, -ratio);
          galaxy.player.addCargo(encounter.goodSold, ratio * encounter.goodRatio);
          updateLabels();
        }
      }
    }
  }

  public function tradeFuel(ratio:Int):UIButton->Void
  {
    return function(button:UIButton):Void {
      if(galaxy.player.cargos.get(encounter.goodBought) >= ratio) {
        if(encounter.fuelInventory >= ratio * encounter.goodRatio) {
          encounter.fuelInventory -= ratio * encounter.fuelRatio;
          galaxy.player.addCargo(encounter.goodBought, -ratio);
          galaxy.player.addResource("fuel", ratio * encounter.fuelRatio);
          updateLabels();
        }
      }
    }
  }

  public function closePanel(button:UIButton):Void
  {
    cast(scene, GameController).exitFriendly();
  }

  public override function update()
  {
    super.update();
    panel.update();
  }
}
