package com.saturnia;

import com.modality.Base;

class Card extends Base
{
  public var card_name:String;

  public var playable:Bool;

  public var has_strategy:Bool;
  public var strategy_trigger:String;
  public var strategy_effect:String;

  public var has_action:Bool;
  public var action_effect:String;

  public var has_reaction:Bool;
  public var reaction_trigger:String;
  public var reaction_effect:String;

  public function new()
  {
    super();
    type = "card";
    playable = false;
    this.graphic = Assets.getImage("ui_card");
    //updateGraphic();
  }

  public function updateGraphic()
  {
    //this.graphic = Assets.getImage("tarot_"+number);
    //setHitboxTo(this.graphic);
  }
  
  public function pickUp()
  {
    image.scaleX = 1.1;
    image.scaleY = 1.1;
  }

  public function putDown()
  {
    image.scaleX = 1;
    image.scaleY = 1;
  }
}
