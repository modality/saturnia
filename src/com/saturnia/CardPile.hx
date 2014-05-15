package com.saturnia;

import com.modality.Base;

class CardPile extends Base
{
  public var playFn:Card->Bool;

  public function new(_x:Float = 0, _y:Float = 0, _playFn:Card->Bool = null)
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

  public function playCard(card:Card):Bool
  {
    if(playFn != null) {
      return playFn(card);
    }
    return false;
  }

  public function updateGraphic()
  {
    setHitboxTo(this.graphic);
  }
}
