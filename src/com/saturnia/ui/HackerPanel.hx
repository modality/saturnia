package com.saturnia.ui;

import openfl.events.Event;
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
    panel.addChild(new UILabel("Total Science: "+galaxy.player.science), UIAlign.FloatRight);
    panel.addChild(new UILabel("Network Power: "+galaxy.operatorsActive), UIAlign.FloatLeft);
    panel.addNamedChild("hack attempts", new UILabel("Hack Attempts: "+galaxy.hackAttempts), UIAlign.Center);
    panel.addChild(new UISpacer(660, 40, true), UIAlign.Left);

    leftPanel.addChild(new UILabel("Hack Systems", Constants.FONT_SIZE_MD), UIAlign.Left);
    leftPanel.addChild(new UISpacer(300, 20), UIAlign.Left);

    success = Math.floor(calculateSuccess(galaxy.player.initiative) * 100);
    leftPanel.addNamedChild("hack initiative label", new UILabel("MOVE - "+galaxy.player.initiative), UIAlign.FloatLeft);
    leftPanel.addNamedChild("hack initiative button", new UIButton(100, 30, "HACK ("+success+"%)", hackFunction("initiative")), UIAlign.Right);
    leftPanel.addChild(new UISpacer(300, 10), UIAlign.Left);

    success = Math.floor(calculateSuccess(galaxy.player.evasion) * 100);
    leftPanel.addNamedChild("hack evasion label", new UILabel("EVAD - "+galaxy.player.evasion), UIAlign.FloatLeft);
    leftPanel.addNamedChild("hack evasion button", new UIButton(100, 30, "HACK ("+success+"%)", hackFunction("evasion")), UIAlign.Right);
    leftPanel.addChild(new UISpacer(300, 10), UIAlign.Left);

    success = Math.floor(calculateSuccess(galaxy.player.targeting) * 100);
    leftPanel.addNamedChild("hack targeting label", new UILabel("TRGT - "+galaxy.player.targeting), UIAlign.FloatLeft);
    leftPanel.addNamedChild("hack targeting button", new UIButton(100, 30, "HACK ("+success+"%)", hackFunction("targeting")), UIAlign.Right);
    leftPanel.addChild(new UISpacer(300, 10), UIAlign.Left);

    success = Math.floor(calculateSuccess(galaxy.player.damage) * 100);
    leftPanel.addNamedChild("hack damage label", new UILabel("LASR - "+galaxy.player.damage), UIAlign.FloatLeft);
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
        case "initiative": galaxy.player.initiative;
        case "evasion": galaxy.player.evasion;
        case "targeting": galaxy.player.targeting;
        case "damage": galaxy.player.damage;
        default: return;
      }

      var success = Math.random() < calculateSuccess(startValue);
      var systemName;

      if(success) {
        switch(system) {
          case "initiative":
            if(galaxy.player.initiative < 10) galaxy.player.initiative += 1;
            systemName = "MOVE";
          case "evasion":
            if(galaxy.player.evasion < 10) galaxy.player.evasion += 1;
            systemName = "EVAD";
          case "targeting":
            if(galaxy.player.targeting < 10) galaxy.player.targeting += 1;
            systemName = "TRGT";
          case "damage":
            if(galaxy.player.damage < 10) galaxy.player.damage += 1;
            systemName = "LASR";
          default: return;
        }

        showPopup("Successfully hacked "+systemName+" program. Program level increased from "+startValue+" to "+(startValue+1)+".");
      } else {
        switch(system) {
          case "initiative":
            if(galaxy.player.initiative > 1) galaxy.player.initiative -= 1;
            systemName = "MOVE";
          case "evasion":
            if(galaxy.player.evasion > 1) galaxy.player.evasion -= 1;
            systemName = "EVAD";
          case "targeting":
            if(galaxy.player.targeting > 1) galaxy.player.targeting -= 1;
            systemName = "TRGT";
          case "damage":
            if(galaxy.player.damage > 1) galaxy.player.damage -= 1;
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
    success = Math.floor(calculateSuccess(galaxy.player.initiative) * 100);
    leftPanel.getChild("hack initiative label").updateText("MOVE - "+galaxy.player.initiative);
    leftPanel.getChild("hack initiative button").updateText("HACK ("+success+"%)");

    success = Math.floor(calculateSuccess(galaxy.player.evasion) * 100);
    leftPanel.getChild("hack evasion label").updateText("EVAD - "+galaxy.player.evasion);
    leftPanel.getChild("hack evasion button").updateText("HACK ("+success+"%)");

    success = Math.floor(calculateSuccess(galaxy.player.targeting) * 100);
    leftPanel.getChild("hack targeting label").updateText("TRGT - "+galaxy.player.targeting);
    leftPanel.getChild("hack targeting button").updateText("HACK ("+success+"%)");

    success = Math.floor(calculateSuccess(galaxy.player.damage) * 100);
    leftPanel.getChild("hack damage label").updateText("LASR - "+galaxy.player.damage);
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
}

