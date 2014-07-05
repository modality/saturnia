package com.saturnia.data;

import com.modality.cards.Message;

class CardData
{
  public var id:String;
  public var rules:Array<CardRuleData>;

  public function new()
  {
    rules = [];
  }

  public function getRule(type:String):CardRuleData
  {
    for(rule in rules) {
      if(rule.type == type) {
	return rule;
      }
    }
    return null;
  }

  public function getMessage(type:String):Message
  {
    var rule = getRule(type);
    if(rule != null) {
      return rule.rule;
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

  public function getExplainText():String
  {
    var explain = "";

    for(rule in rules) {
      var coltag = switch(rule.type) {
        case "strategy": "col_strategy";
        case "action": "col_action";
        case "reaction": "col_reaction";
        default: "nothing";
      }
      explain += "<"+coltag+">"+rule.name+" ("+rule.type+")</"+coltag+">\n";
      explain += rule.text + "\n\n";
      explain += "<rule>" + rule.rule + "</rule>\n\n";
    }

    return explain;
  }

  public static function fromYamlObj(obj:Dynamic):CardData
  {
    //trace("Building card: "+obj.id);
    var card = new CardData();
    card.id = obj.id;

    for(rule in cast(obj.rules, Array<Dynamic>)) {
      card.rules.push(CardRuleData.fromYamlObj(rule));
    }

    return card;
  }
}
