package com.saturnia;

import flash.events.Event;
import com.modality.Base;
import com.modality.TextBase;

import com.saturnia.inventory.Inventory;

class Inspector extends Base
{
  public var inv:Inventory;

  public var sectorName:TextBase;
  public var fuel_icon:Base;
  public var fuel_text:TextBase;
  public var shields_icon:Base;
  public var shields_text:TextBase;
  public var cargo_icon:Base;
  public var cargo_text:TextBase;
  public var science_icon:Base;
  public var science_text:TextBase;

  public var explainText:TextBase;

  public function new(_inv:Inventory)
  {
    super();

    inv = _inv;

    this.x = Constants.INSPECTOR_X;
    this.y = Constants.INSPECTOR_Y;

    sectorName = new TextBase();
    sectorName.size = Constants.FONT_SIZE_MD;
    sectorName.x = 0;
    sectorName.y = 5;

    fuel_icon = new Base(0, 30, Assets.getImage("icon_fuel"));
    fuel_text = new TextBase(25, 31, 0, 0, ""+inv.fuel);
    fuel_text.color = Constants.FUEL_COLOR;
    fuel_icon.layer = Constants.RESOURCE_LAYER;
    fuel_text.layer = Constants.RESOURCE_LAYER;

    shields_icon = new Base(70, 30, Assets.getImage("icon_shields"));
    shields_text = new TextBase(95, 31, 0, 0, ""+inv.shields);
    shields_text.color = Constants.SHIELDS_COLOR;
    shields_icon.layer = Constants.RESOURCE_LAYER;
    shields_text.layer = Constants.RESOURCE_LAYER;

    cargo_icon = new Base(140, 30, Assets.getImage("icon_cargo"));
    cargo_text = new TextBase(165, 31, 0, 0, ""+inv.cargo);
    cargo_text.color = Constants.CARGO_COLOR;
    cargo_icon.layer = Constants.RESOURCE_LAYER;
    cargo_text.layer = Constants.RESOURCE_LAYER;

    science_icon = new Base(210, 30, Assets.getImage("icon_science"));
    science_text = new TextBase(235, 31, 0, 0, ""+inv.science);
    science_text.color = Constants.SCIENCE_COLOR;
    science_icon.layer = Constants.RESOURCE_LAYER;
    science_text.layer = Constants.RESOURCE_LAYER;

    explainText = new TextBase(0, 60, 256, 0);
    explainText.textObj.wordWrap = true;
    explainText.size = 16;
    explainText.textObj.addStyle("col_strategy", {color: 0x00FFCC});
    explainText.textObj.addStyle("col_action", {color: 0xFF00CC});
    explainText.textObj.addStyle("col_reaction", {color: 0xFFCC00});
    explainText.textObj.addStyle("rule", {size: 12, color:0xCCCCCC});

    addChild(sectorName);
    addChild(fuel_icon);
    addChild(fuel_text);
    addChild(shields_icon);
    addChild(shields_text);
    addChild(cargo_icon);
    addChild(cargo_text);
    addChild(science_icon);
    addChild(science_text);
    addChild(explainText);
  }

  public override function added()
  {
    super.added();
    updateGraphic();
  }

  public override function updateGraphic()
  {
    super.updateGraphic();
    fuel_text.text = ""+inv.fuel;
    shields_text.text = ""+inv.shields;
    cargo_text.text = ""+inv.cargo;
    science_text.text = ""+inv.science;
  }

  public function setExplain(text:String):Void
  {
    explainText.richText = text;
  }
}
