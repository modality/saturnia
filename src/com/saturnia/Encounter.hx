package com.saturnia;

import com.haxepunk.graphics.Image;
import com.modality.Base;
import com.saturnia.inventory.Inventory;

class Encounter extends Base
{
  public var space:Space;
  public var inventory:Inventory;

  public function new(_space:Space)
  {
    super();
    space = _space;
    inventory = new Inventory(3, 3, 3, 3);
  }

  public function activate()
  {
  }

}
