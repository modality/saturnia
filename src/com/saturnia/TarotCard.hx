package com.saturnia;

import com.modality.Base;

class TarotCard extends Base
{
  public var card_name:String;
  public var element:String;
  public var number:Int;

  public var selected:Bool;
  public var position:Int;

  public function new(_card_name:String, _element:String, _number:Int)
  {
    super();
    card_name = _card_name;
    element = _element;
    number = _number;
    type = "tarot_card";
    updateGraphic();
    reset();
  }

  public function updateGraphic()
  {
    this.graphic = Assets.getImage("tarot_"+number);
    setHitboxTo(this.graphic);
  }

  public function reset()
  {
    selected = false;
    position = 0;
  }
}
