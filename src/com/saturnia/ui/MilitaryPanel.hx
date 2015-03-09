package com.saturnia.ui;

import com.modality.Base;
import com.modality.TextBase;
import com.modality.ui.UIPanel;
import com.modality.ui.UIAlign;
import com.modality.ui.UILabel;
import com.modality.ui.UIButton;
import com.modality.ui.UISpacer;
import com.modality.AugRandom;

class MilitaryPanel extends Base
{
  public var encounter:MilitaryEncounter;
  public var galaxy:Galaxy;

  public var panel:UIPanel;
  public var leftPanel:UIPanel;
  public var rightPanel:UIPanel;

  public var contractLength:Int;
  public var contractPrice:Int;

  public function new(_space:Space, _galaxy:Galaxy)
  {
    super(50, 50);

    encounter = cast(_space.encounter, MilitaryEncounter);
    galaxy = _galaxy;

    var modal = Assets.getImage("ui_modal");
    modal.scaleX = 700;
    modal.scaleY = 500;
    this.graphic = modal;
    this.layer = Constants.OVERLAY_LAYER;

    panel = new UIPanel(20, 20, 660, 460);
    leftPanel = new UIPanel(0, 0, 300, 0);
    rightPanel = new UIPanel(0, 0, 300, 0);

    contractLength = 1;
    contractPrice = 0;

    panel.addChild(new UILabel("Condottieri PMC", Constants.FONT_SIZE_LG), UIAlign.Left);
    panel.addChild(new UISpacer(660, 20), UIAlign.Left);
    panel.addChild(new UILabel("Enemies: 4 pirates"), UIAlign.FloatLeft);
    panel.addChild(new UILabel("Next Cycle: "+galaxy.cycleCounter+" turns"), UIAlign.FloatRight);
    panel.addChild(new UILabel("Sector Explored: 64%"), UIAlign.Center);
    panel.addChild(new UISpacer(660, 40, true), UIAlign.Left);

    panel.addChild(new UILabel("Policing Contract", Constants.FONT_SIZE_MD), UIAlign.Left);

    if(galaxy.policingContract > 0) {
      panel.addChild(new UILabel("You cannot enter a new contract until the contract in effect expires."), UIAlign.Left);
      panel.addChild(new UILabel("The current policing contract expires in "+galaxy.policingContract+" cycle"+(galaxy.policingContract>1 ? "s" :"")+". Have a nice day. :)"), UIAlign.Left);
    } else {
      leftPanel.addChild(new UISpacer(300, 20), UIAlign.Left);

      var contract:Array<String> = [
        "Known knowns",
        "Unknown unknowns",
        "Base outlay",
        "Service charge",
        "Danger assessment",
        "Beeswax, official",
        "Room and board, beekeeper",
        "Mood lighting",
        "Minibar, organic",
        "Travel insurance, beehive",
        "Bee chow",
        "Hydroponic clover",
        "Hood ornament polish",
        "Depollenization process",
        "Anti-pirate ammunition",
        "Training video licensing fee",
        "Conscription fee",
        "Ointment, 64oz. tublet",
        "Printer ink",
        "Computer paper",
        "Dry cleaning fee",
        "Ceremonial orbs",
        "Side dishes",
      ];

      contract = AugRandom.sample(contract, 5);

      for(item in contract) {
        leftPanel.addChild(new UILabel(item), UIAlign.Left);
      }

      leftPanel.addChild(new UILabel("Total: "+contractPrice+" cargo"), UIAlign.Left);

      rightPanel.addChild(new UILabel("Contract Length"), UIAlign.Left);
      rightPanel.addChild(new UIButton(40, 30, "+", increaseContractLength), UIAlign.FloatRight);
      rightPanel.addNamedChild("contract length label", new UILabel(contractLength+" cycle"), UIAlign.FloatCenter);
      rightPanel.addChild(new UIButton(40, 30, "-", decreaseContractLength), UIAlign.Left);

      rightPanel.addNamedChild("sign contract button", new UIButton(150, 30, "Sign Contract", signContract), UIAlign.Center);

      panel.addChild(rightPanel, UIAlign.FloatRight);
      panel.addChild(leftPanel, UIAlign.Left);
    }

    panel.addChild(new UISpacer(660, 40, true), UIAlign.Left);
    panel.addChild(new UIButton(150, 50, "CLOSE", closePanel), UIAlign.Center);

    addChild(panel.entity);

    panel.updateGraphic();
  }

  public function increaseContractLength(button:UIButton):Void
  {
    contractLength++;
    updateTerms();
  }

  public function decreaseContractLength(button:UIButton):Void
  {
    contractLength--;
    if(contractLength < 1) contractLength = 1;
    updateTerms();
  }

  public function updateTerms():Void
  {
    rightPanel.getChild("contract length label").updateText(contractLength+" cycle"+(contractLength > 1 ? "s" : ""));
    rightPanel.getChild("sign contract button").active = contractPrice <= galaxy.player.totalCargo(); 
    rightPanel.getChild("sign contract button").updateGraphic();
  }

  public function signContract(button:UIButton):Void
  {
    galaxy.player.spendCargo(contractPrice);
    galaxy.player.updated();
    galaxy.policingContract += contractLength;
    closePanel(button);
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


