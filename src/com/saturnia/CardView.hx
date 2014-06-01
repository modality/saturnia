package com.saturnia;

import com.modality.Base;
import com.modality.TextBase;

class CardView extends Base
{
  public var card:Card;
  public var nameText:TextBase;

  public var playable:Bool;

  public function new(_card:Card)
  {
    super();
    card = _card;
    type = "card";
    playable = false;
    this.graphic = Assets.getImage("ui_card");
    nameText = new TextBase(0, 0, 80);
    nameText.size = 12;
    nameText.textObj.wordWrap = true;
    addChild(nameText);
    updateGraphic();
  }

  public function updateGraphic()
  {
    setHitboxTo(this.graphic);
    nameText.text = this.card.rules[0].name;
  }

  public function moveGraphic(_x:Float, _y:Float)
  {
    graphic.x = _x;
    graphic.y = _y;
    nameText.graphic.x = _x;
    nameText.graphic.y = _y;
  }

  public function move(_x:Float, _y:Float)
  {
    x = _x;
    y = _y;
    nameText.x = _x;
    nameText.y = _y;
    moveGraphic(0, 0);
  }

  public function pickUp()
  {
    image.scaleX = 1.1;
    image.scaleY = 1.1;
    alpha = 0.7;
  }

  public function putDown()
  {
    image.scaleX = 1;
    image.scaleY = 1;
    alpha = 1;
  }
}

