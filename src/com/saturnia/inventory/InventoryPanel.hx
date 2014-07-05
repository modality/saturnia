package com.saturnia.inventory;

import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;

class InventoryPanel extends Base {
  public var inv:Inventory;

  public function new(_inv:Inventory)
  {
    super(0, 0);
    inv = _inv;
  }
}
