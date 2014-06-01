package com.saturnia;

import com.modality.cards.Message;

class Card
{
  public var id:String;
  public var rules:Array<CardRule>;

  public function new()
  {
    rules = [];
  }

  public function getRule(type:String):Message
  {
    for(rule in rules) {
      if(rule.type == type) {
	return rule.rule;
      }
    }
    return null;
  }

  public function hasRule(type:String):Bool
  {
    for(rule in rules) {
      if(rule.type == type) {
	return true;
      }
    }
    return false;
  }

  public static function fromYamlObj(obj:Dynamic):Card
  {
    //trace("Building card: "+obj.id);
    var card = new Card();
    card.id = obj.id;

    for(rule in cast(obj.rules, Array<Dynamic>)) {
      card.rules.push(CardRule.fromYamlObj(rule));
    }

    return card;
  }
}
