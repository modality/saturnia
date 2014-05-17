package com.saturnia;

import flash.events.Event;
import com.modality.Base;
import com.modality.TextBase;

class PlayerResources extends Base
{
  public var inv:Inventory;

  public var fuel_icon:Base;
  public var fuel_text:TextBase;
  public var shields_icon:Base;
  public var shields_text:TextBase;
  public var cargo_icon:Base;
  public var cargo_text:TextBase;
  public var science_icon:Base;
  public var science_text:TextBase;

  public function new()
  {
    super();

    inv = new Inventory(Constants.STARTING_FUEL,
                        Constants.STARTING_SHIELDS,
                        Constants.STARTING_CARGO,
                        Constants.STARTING_SCIENCE);

    fuel_icon = new Base(0, 0, Assets.getImage("icon_fuel"));
    fuel_text = new TextBase(25, 1, ""+inv.fuel);
    fuel_text.color = Constants.FUEL_COLOR;
    fuel_icon.layer = Constants.RESOURCE_LAYER;
    fuel_text.layer = Constants.RESOURCE_LAYER;

    shields_icon = new Base(70, 0, Assets.getImage("icon_shields"));
    shields_text = new TextBase(95, 1, ""+inv.shields);
    shields_text.color = Constants.SHIELDS_COLOR;
    shields_icon.layer = Constants.RESOURCE_LAYER;
    shields_text.layer = Constants.RESOURCE_LAYER;

    cargo_icon = new Base(140, 0, Assets.getImage("icon_cargo"));
    cargo_text = new TextBase(165, 1, ""+inv.cargo);
    cargo_text.color = Constants.CARGO_COLOR;
    cargo_icon.layer = Constants.RESOURCE_LAYER;
    cargo_text.layer = Constants.RESOURCE_LAYER;

    science_icon = new Base(210, 0, Assets.getImage("icon_science"));
    science_text = new TextBase(235, 1, ""+inv.science);
    science_text.color = Constants.SCIENCE_COLOR;
    science_icon.layer = Constants.RESOURCE_LAYER;
    science_text.layer = Constants.RESOURCE_LAYER;
  }

  public override function added()
  {
    scene.add(fuel_icon);
    scene.add(fuel_text);
    scene.add(shields_icon);
    scene.add(shields_text);
    scene.add(cargo_icon);
    scene.add(cargo_text);
    scene.add(science_icon);
    scene.add(science_text);
    updateGraphic();
  }

  public function useFuel(amount:Int)
  {
    inv.fuel -= amount;
    fuel_text.text = ""+inv.fuel;
  }

  public function updateGraphic()
  {
    fuel_text.text = ""+inv.fuel;
    shields_text.text = ""+inv.shields;
    cargo_text.text = ""+inv.cargo;
    science_text.text = ""+inv.science;
  }
}
