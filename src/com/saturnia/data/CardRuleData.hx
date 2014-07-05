package com.saturnia.data;

import com.modality.cards.Message;

class CardRuleData
{
  public var name:String;
  public var text:String;
  public var type:String;
  public var rule:Message;

  public function new() { }

  public static function fromYamlObj(obj:Dynamic):CardRuleData
  {
    //trace("Building rule: "+obj.name);
    var rule = new CardRuleData();

    rule.name = obj.name;
    rule.text = obj.text;
    rule.type = obj.type;
    rule.rule = Message.read(obj.rule);

    return rule;
  }
}
