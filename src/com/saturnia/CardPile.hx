package com.saturnia;

import com.modality.Base;

class CardPile extends Base
{
  public function new(_x:Float = 0, _y:Float = 0)
  {
    super(_x, _y, Assets.getImage("ui_pile"));
    blur();
  }

  public function focus()
  {
    alpha = 1;
  }

  public function blur()
  {
    alpha = 0.8;
  }

}
