package com.modality.cards;

class Invoker implements Receiver {
  public var game:Receiver;
  public var rules:Array<Message>; // specify what types of events are valid
  public var triggers:Array<Message>; // specify what happens when events are fired
  public var history:Array<Message>;

  public function new(_game:Receiver)
  {
    game = _game;
    rules = [];
    triggers = [];
    history = [];
  }

  public function execute(message:Message):Void
  {
    var msg = message.eval(this);
    trace(msg);
    history.push(msg);
  }

  public function eval(message:Message):Message
  {
    switch(message.type()) {
      case "rule":
        rules.push(message);
        return Message.read("(addedRule ("+message.toString()+"))");
      case "trigger":
        triggers.push(message);
        return Message.read("(addedTrigger ("+message.toString()+"))");
      default:
        if(matchRules(message)) {
          var matched = matchTriggers(message);

          var interrupt = false;

          for(trigger in matched) {
            interrupt = interrupt || trigger.tokens[3];
            if(trigger.tokens[4]) {
              triggers.remove(trigger);
            }
            execute(new Message(trigger.tokens[2]));
          }

          if(interrupt) {
            return Message.read("(interrupt ("+message.toString()+"))");
          }

          return game.eval(message);
        } else {
          return Message.read("(noRule ("+message.toString()+"))");
        }
    }
    return Message.read("(error)");
  }

  public function matchRules(input:Message):Bool
  {
    for(rule in rules) {
      var ruleMsg = new Message(rule.tokens[1]);
      if(matchMessage(ruleMsg, input)) {
        return true;
      }
    }
    return false;
  }

  public function matchTriggers(input:Message):Array<Message>
  {
    var matched = [];

    for(trigger in triggers) {
      var trigMsg = new Message(trigger.tokens[1]);
      if(matchMessage(trigMsg, input)) {
        matched.push(trigger);
      }
    }

    return matched;
  }

  public function matchMessage(base:Message, input:Message):Bool
  {
    for(i in 0...base.tokens.length) {
      if(base.tokens[i] != input.tokens[i]) {
        return false;
      }
    }
    return true;
  }
}
