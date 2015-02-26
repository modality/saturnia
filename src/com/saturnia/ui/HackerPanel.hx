package com.saturnia.ui;

import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;
import com.modality.ui.UIPanel;
import com.modality.ui.UIAlign;
import com.modality.ui.UILabel;
import com.modality.ui.UIButton;
import com.modality.ui.UISpacer;

class HackerPanel extends Base
{
  public var encounter:HackerEncounter;
  public var galaxy:Galaxy;

  public var panel:UIPanel;
  public var leftPanel:UIPanel;
  public var rightPanel:UIPanel;

  public function new(_space:Space, _galaxy:Galaxy)
  {
    super(50, 50);

    //encounter = cast(_space.encounter, HackerEncounter);
    galaxy = _galaxy;

    var modal = Assets.getImage("ui_modal");
    modal.scaleX = 700;
    modal.scaleY = 500;
    this.graphic = modal;
    this.layer = Constants.OVERLAY_LAYER;

    panel = new UIPanel(20, 20, 660, 460);
    leftPanel = new UIPanel(0, 0, 300, 0);
    rightPanel = new UIPanel(0, 0, 300, 0);

    var success;

    panel.addChild(new UILabel("The Operators", Constants.FONT_SIZE_LG), UIAlign.Left);
    panel.addChild(new UISpacer(660, 20), UIAlign.Left);
    panel.addChild(new UILabel("Network Power: "+galaxy.operatorsActive), UIAlign.FloatLeft);
    panel.addChild(new UILabel("Total Science: "+galaxy.player.science), UIAlign.FloatRight);
    panel.addNamedChild("hack attempts", new UILabel("Hack Attempts: "+galaxy.hackAttempts), UIAlign.Center);
    panel.addChild(new UISpacer(660, 40, true), UIAlign.Left);

    leftPanel.addChild(new UILabel("Hack Systems", Constants.FONT_SIZE_MD), UIAlign.Left);
    leftPanel.addChild(new UISpacer(300, 20), UIAlign.Left);

    success = Math.floor(calculateSuccess(galaxy.player.progInitiative) * 100);
    leftPanel.addNamedChild("hack initiative label", new UILabel("MOVE - "+galaxy.player.progInitiative), UIAlign.FloatLeft);
    leftPanel.addNamedChild("hack initiative button", new UIButton(100, 30, "HACK ("+success+"%)", hackFunction("initiative")), UIAlign.Right);
    leftPanel.addChild(new UISpacer(300, 10), UIAlign.Left);

    success = Math.floor(calculateSuccess(galaxy.player.progEvasion) * 100);
    leftPanel.addNamedChild("hack evasion label", new UILabel("EVAD - "+galaxy.player.progEvasion), UIAlign.FloatLeft);
    leftPanel.addNamedChild("hack evasion button", new UIButton(100, 30, "HACK ("+success+"%)", hackFunction("evasion")), UIAlign.Right);
    leftPanel.addChild(new UISpacer(300, 10), UIAlign.Left);

    success = Math.floor(calculateSuccess(galaxy.player.progShield) * 100);
    leftPanel.addNamedChild("hack shield label", new UILabel("SHLD - "+galaxy.player.progShield), UIAlign.FloatLeft);
    leftPanel.addNamedChild("hack shield button", new UIButton(100, 30, "HACK ("+success+"%)", hackFunction("shield")), UIAlign.Right);
    leftPanel.addChild(new UISpacer(300, 10), UIAlign.Left);

    success = Math.floor(calculateSuccess(galaxy.player.progDamage) * 100);
    leftPanel.addNamedChild("hack damage label", new UILabel("LASR - "+galaxy.player.progDamage), UIAlign.FloatLeft);
    leftPanel.addNamedChild("hack damage button", new UIButton(100, 30, "HACK ("+success+"%)", hackFunction("damage")), UIAlign.Right);

    rightPanel.addChild(new UILabel("Modify Timescale", Constants.FONT_SIZE_MD), UIAlign.Left);
    rightPanel.addChild(new UIButton(150, 30, "Cycle Length +1"), UIAlign.FloatRight);
    rightPanel.addChild(new UILabel("Increase"), UIAlign.Left);
    rightPanel.addChild(new UIButton(150, 30, "Cycle Length -1"), UIAlign.FloatRight);
    rightPanel.addChild(new UILabel("Decrease"), UIAlign.Left);

    panel.addChild(rightPanel, UIAlign.FloatRight);
    panel.addChild(leftPanel, UIAlign.Left);
    panel.addChild(new UISpacer(660, 40, true), UIAlign.Left);
    panel.addChild(new UIButton(150, 50, "CLOSE", closePanel), UIAlign.Center);

    addChild(panel.entity);

    panel.updateGraphic();
  }

  public function calculateSuccess(startValue:Int):Float
  {
    var science = galaxy.player.science;
    var network = galaxy.operatorsActive;
    var attempts = galaxy.hackAttempts;
    var chance = Math.pow(0.85, startValue) *
                 Math.pow(0.97, attempts) *
                 (Math.log(network+10)-2) *
                 Math.pow(Math.log(science+2), 1.1);

    if(chance < 0.01 || science == 0) {
      return 0;
    } else if(chance > 0.99) {
      return 1;
    }
    return chance;
  }

  public function hackFunction(system:String):UIButton->Void
  {
    return function(button:UIButton) {
      var startValue = switch(system) {
        case "initiative": galaxy.player.progInitiative;
        case "evasion": galaxy.player.progEvasion;
        case "shield": galaxy.player.progShield;
        case "damage": galaxy.player.progDamage;
        default: return;
      }

      var success = Math.random() < calculateSuccess(startValue);
      var systemName;

      if(success) {
        switch(system) {
          case "initiative":
            if(galaxy.player.progInitiative < 10) galaxy.player.progInitiative += 1;
            systemName = "MOVE";
          case "evasion":
            if(galaxy.player.progEvasion < 10) galaxy.player.progEvasion += 1;
            systemName = "EVAD";
          case "shield":
            if(galaxy.player.progShield < 10) galaxy.player.progShield += 1;
            systemName = "SHLD";
          case "damage":
            if(galaxy.player.progDamage < 10) galaxy.player.progDamage += 1;
            systemName = "LASR";
          default: return;
        }

        showPopup("Successfully hacked "+systemName+" program. Program level increased from "+startValue+" to "+(startValue+1)+".");
      } else {
        switch(system) {
          case "initiative":
            if(galaxy.player.progInitiative > 1) galaxy.player.progInitiative -= 1;
            systemName = "MOVE";
          case "evasion":
            if(galaxy.player.progEvasion > 1) galaxy.player.progEvasion -= 1;
            systemName = "EVAD";
          case "shield":
            if(galaxy.player.progShield > 1) galaxy.player.progShield -= 1;
            systemName = "SHLD";
          case "damage":
            if(galaxy.player.progDamage > 1) galaxy.player.progDamage -= 1;
            systemName = "LASR";
          default: return;
        }

        showPopup("Failed to hack "+systemName+" program. Program level fell from "+startValue+" to "+(startValue-1)+".");
      }

      button.active = false;
      button.updateGraphic();
      galaxy.hackAttempts += 1;
      updateLabels();
    }
  }

  public function updateLabels():Void
  {
    panel.getChild("hack attempts").updateText("Hack Attempts: "+galaxy.hackAttempts);

    var success; 
    success = Math.floor(calculateSuccess(galaxy.player.progInitiative) * 100);
    leftPanel.getChild("hack initiative label").updateText("MOVE - "+galaxy.player.progInitiative);
    leftPanel.getChild("hack initiative button").updateText("HACK ("+success+"%)");

    success = Math.floor(calculateSuccess(galaxy.player.progEvasion) * 100);
    leftPanel.getChild("hack evasion label").updateText("EVAD - "+galaxy.player.progEvasion);
    leftPanel.getChild("hack evasion button").updateText("HACK ("+success+"%)");

    success = Math.floor(calculateSuccess(galaxy.player.progShield) * 100);
    leftPanel.getChild("hack shield label").updateText("SHLD - "+galaxy.player.progShield);
    leftPanel.getChild("hack shield button").updateText("HACK ("+success+"%)");

    success = Math.floor(calculateSuccess(galaxy.player.progDamage) * 100);
    leftPanel.getChild("hack damage label").updateText("LASR - "+galaxy.player.progDamage);
    leftPanel.getChild("hack damage button").updateText("HACK ("+success+"%)");
  }

  public function showPopup(message:String):Void
  {
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

