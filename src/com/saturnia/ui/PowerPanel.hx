package com.saturnia.ui;

import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;

class PowerPanel extends Base
{
  public var galaxy:Galaxy;
  public var player:PlayerResources;
  public var cycleIcon:Base;
  public var cycleText:TextBase;
  public var cycleNumber:TextBase;
  public var energyBar:ResourceBar;

  public var powers:Array<PowerMenuItem>;

  public function new(_galaxy:Galaxy)
  {
    super(0, 500);
    galaxy = _galaxy;
    player = galaxy.player;

    cycleIcon = new Base(0, 0, Assets.getImage("icon_cycle"));
    cycleIcon.image.scaleX = 5;
    cycleIcon.image.scaleY = 5;

    cycleText = new TextBase(0, 25, 100, 20, "Next Cycle");
    cycleText.size = Constants.FONT_SIZE_XS;
    cycleText.align = "center";

    cycleNumber = new TextBase(0, 45, 100, 30, ""+galaxy.cycleCounter);
    cycleNumber.size = Constants.FONT_SIZE_LG;
    cycleNumber.align = "center";

    energyBar = new ResourceBar(100, 0, 375, 20, "energy", Constants.ENERGY_COLOR);
    energyBar.set(player.energy, player.maxEnergy);
    energyBar.text.color = 0x000000;

    addChild(cycleIcon);
    addChild(cycleText);
    addChild(cycleNumber);
    addChild(energyBar);

    powers = [];

    player.addEventListener(ShipPartEvent.ADD, addPower);
    for (sp in player.shipParts) {
      addPower(new ShipPartEvent(ShipPartEvent.ADD, sp));
    }
  }

  public function pulse()
  {
    cycleNumber.text = ""+galaxy.cycleCounter;
    energyBar.set(player.energy, player.maxEnergy);
  }

  public function addPower(e:ShipPartEvent)
  {
    powers.push(new PowerMenuItem(0, 0, e.shipPart.effectName, e.shipPart.energyCost));

    var index = powers.length - 1;
    powers[index].x = 100 + 110*index;
    powers[index].y = 20;
    addChild(powers[index]);
  }
}
