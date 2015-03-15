package com.saturnia.ui;

import com.modality.Base;
import com.modality.ui.UIPanel;
import com.modality.ui.UIAlign;
import com.modality.ui.UILabel;
import com.modality.ui.UIButton;
import com.modality.ui.UIImage;

class PowerMenuItem extends Base
{
  public static var CLICKED:String = "clicked item";

  public var shipPart:ShipPart;
  public var panel:UIPanel;

  public function new(_x:Int, _y:Int, _shipPart:ShipPart, _useCallback:ShipPart->Void)
  {
    super(_x, _y);
    shipPart = _shipPart;

    panel = new UIPanel(0, 0, 80, 100);

    panel.addChild(new UILabel(shipPart.effectName, Constants.FONT_SIZE_SM), UIAlign.Left);
    panel.addChild(new UIButton(80, 30, "USE", function(button:UIButton) {
      _useCallback(shipPart);
    }), UIAlign.Left);
    panel.addChild(new UILabel(""+shipPart.energyCost, Constants.FONT_SIZE_MD), UIAlign.FloatLeft);
    panel.addChild(new UIImage("icon_energy"), UIAlign.Right);

    addChild(panel.entity);
    panel.updateGraphic();
  }

  public override function update()
  {
    super.update();
    panel.update();
  }
}
