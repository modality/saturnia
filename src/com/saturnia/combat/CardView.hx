package com.saturnia.combat;

import com.modality.Base;
import com.modality.TextBase;
import com.saturnia.data.CardData;

class CardView extends Base
{
  public var card:CardData;
  public var nameText:TextBase;
  public var nameText2:TextBase;

  public var playable:Bool;

  public function new(_card:CardData)
  {
    super();
    card = _card;
    type = "card";
    playable = false;

    nameText = new TextBase(0, 0, 76);
    nameText.size = 12;
    nameText.textObj.wordWrap = true;

    nameText2 = new TextBase(0, 0, 76);
    nameText2.size = 12;
    nameText2.textObj.wordWrap = true;
/*
#if (flash || js)
    nameText2.textObj.align = flash.text.TextFormatAlign.RIGHT;
#else
    nameText2.textObj.align = "right";
#end
*/
    addChild(nameText);
    addChild(nameText2);

    updateGraphic();
  }

  public override function updateGraphic()
  {
    super.updateGraphic();
    if(card.hasRule("action")) {
      nameText.text = this.card.getRule("action").name;
      if(card.rules.length == 1) {
        this.graphic = Assets.getImage("card_action");
      } else if(card.hasRule("reaction")) {
        nameText2.text = this.card.getRule("reaction").name;
        this.graphic = Assets.getImage("card_action_reaction");
      } else if(card.hasRule("strategy")) {
        nameText2.text = this.card.getRule("strategy").name;
        this.graphic = Assets.getImage("card_action_strategy");
      }
    } else if(card.hasRule("reaction")) {
      nameText.text = this.card.getRule("reaction").name;
      if(card.rules.length == 1) {
        this.graphic = Assets.getImage("card_reaction");
      } else if(card.hasRule("strategy")) {
        nameText2.text = this.card.getRule("strategy").name;
        this.graphic = Assets.getImage("card_reaction_strategy");
      }
    } else if(card.hasRule("strategy")) {
      nameText.text = this.card.getRule("strategy").name;
      this.graphic = Assets.getImage("card_strategy");
    }

    nameText2.textObj.x = 78 - nameText2.textObj.textWidth;
    nameText2.textObj.y = 98 - nameText2.textObj.textHeight;
    setHitboxTo(this.graphic);
  }

  public function moveGraphic(_x:Float, _y:Float)
  {
    graphic.x = _x;
    graphic.y = _y;
    nameText.graphic.x = _x;
    nameText.graphic.y = _y;
    nameText2.textObj.x = _x + 78 - nameText2.textObj.textWidth;
    nameText2.textObj.y = _y + 98 - nameText2.textObj.textHeight;
  }

  public function move(_x:Float, _y:Float)
  {
    x = _x;
    y = _y;
    nameText.x = _x;
    nameText.y = _y;
    nameText2.x = _x;
    nameText2.y = _y;
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

