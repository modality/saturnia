package com.saturnia.combat;

import com.modality.Base;

class CardPileView extends Base
{
  public var playFn:CardView->Bool;

  public function new(_x:Float = 0, _y:Float = 0, _playFn:CardView->Bool = null)
  {
    super(_x, _y, Assets.getImage("ui_pile"));
    playFn = _playFn;
    type = "cardPile";
    blur();
    updateGraphic();
  }

  public function focus()
  {
    alpha = 0.8;
  }

  public function blur()
  {
    alpha = 0.5;
  }

  public function playCard(card:CardView):Bool
  {
    if(playFn != null) {
      return playFn(card);
    }
    return false;
  }

  public override function updateGraphic()
  {
    super.update();
    updateHitbox();
  }
}
