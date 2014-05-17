package com.saturnia;

import com.modality.Base;
import com.modality.TextBase;

class Card extends Base
{
  public var card_name:String;
  public var nameText:TextBase;

  public var playable:Bool;

  public var has_strategy:Bool = false;
  public var strategy_trigger:String;
  public var strategy_effect:String;

  public var has_action:Bool = false;
  public var action_effect:String;

  public var has_reaction:Bool = false;
  public var reaction_trigger:String;
  public var reaction_effect:String;

  public function new()
  {
    super();
    type = "card";
    card_name = "";
    playable = false;
    this.graphic = Assets.getImage("ui_card");
    nameText = new TextBase();
    addChild(nameText);
    updateGraphic();
  }

  public function updateGraphic()
  {
    setHitboxTo(this.graphic);
    nameText.text = this.card_name;
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
