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
    panel.addNamedChild("enemy count label", new UILabel(""), UIAlign.FloatLeft);
    panel.addNamedChild("cycle count label", new UILabel(""), UIAlign.FloatRight);
    panel.addNamedChild("sector explored label", new UILabel(""), UIAlign.Center);
    panel.addChild(new UISpacer(660, 40, true), UIAlign.Left);

    panel.addChild(new UILabel("Policing Contract", Constants.FONT_SIZE_MD), UIAlign.Left);

    if(galaxy.policingContract > 0) {
      panel.addChild(new UILabel("You cannot enter a new contract until the contract in effect expires."), UIAlign.Left);
      panel.addChild(new UILabel("The current policing contract expires in "+galaxy.policingContract+" cycle"+(galaxy.policingContract>1 ? "s" :"")+". Have a nice day. :)"), UIAlign.Left);
    } else {
      leftPanel.addChild(new UISpacer(300, 20), UIAlign.Left);
      leftPanel.addNamedChild("flat rate label", new UILabel(""), UIAlign.Left);

      var item:String;
      var amount:Int;
      var contractFull:Map<String, Int> = encounter.getFullContract(galaxy);

      for(key in contractFull.keys()) {
        item = StringTools.rpad(key, ".", 25);
        amount = contractFull.get(key);
        if(amount <= 0) {
          amount = 0;
          item += StringTools.lpad("(waived)", ".", 10);
        } else {
          item += StringTools.lpad(""+amount, ".", 10);
        }
        leftPanel.addChild(new UILabel(item), UIAlign.Left);
      }

      leftPanel.addNamedChild("total contract amount", new UILabel(""), UIAlign.Left);

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

    updateTerms();
    panel.updateGraphic();
  }

  public function increaseContractLength(button:UIButton):Void
  {
    contractLength++;
    if(contractLength > 5) contractLength = 5;
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

    var enemyCount = 0;
    var exploredCount = 0;
    var totalSpaces = 0;

    encounter.space.grid.each(function(s:Space, i:Int, j:Int) {
      totalSpaces++;
      if(s.explored) {
        exploredCount++;
        if(s.spaceType == Hostile) {
          enemyCount++;
        }
      }
    });

    var exploredPct = Math.round(100. * exploredCount / totalSpaces);

    panel.getChild("enemy count label").updateText("Enemies: "+enemyCount+" pirates");
    panel.getChild("cycle count label").updateText("Next Cycle: "+galaxy.cycleCounter+" turns");
    panel.getChild("sector explored label").updateText("Sector Explored: "+exploredPct+"%");

    if(galaxy.policingContract < 1) {
      var item:String = StringTools.rpad(encounter.contractFlatName, ".", 25);
      var amount:Int = encounter.contractFlatAmount * contractLength;

      item += StringTools.lpad(""+amount, ".", 10);
      leftPanel.getChild("flat rate label").updateText(item);
      contractPrice = amount;

      var contractFull:Map<String, Int> = encounter.getFullContract(galaxy);
      for(value in contractFull) {
        contractPrice += value;
      }

      var total:String = StringTools.lpad("Total Cargo", " ", 25) +
                         StringTools.lpad(""+contractPrice, ".", 10);
      leftPanel.getChild("total contract amount").updateText(total);
    }
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


