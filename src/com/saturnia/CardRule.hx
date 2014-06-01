package com.saturnia;

import com.modality.cards.Message;

class CardRule
{
  public var name:String;
  public var text:String;
  public var type:String;
  public var rule:Message;

  public function new()
  {

  }

  public static function fromYamlObj(obj:Dynamic):CardRule
  {
    //trace("Building rule: "+obj.name);
    var rule = new CardRule();

    rule.name = obj.name;
    rule.text = obj.text;
    rule.type = obj.type;
    rule.rule = Message.read(obj.rule);

    return rule;
  }
}
