package com.modality.cards;

using Lambda;

class Invoker implements Receiver {
  public var game:Receiver;
  public var triggers:Array<Trigger>; // specify what happens when events are fired
  public var history:Array<Message>;

  public function new(_game:Receiver)
  {
    game = _game;
    triggers = [];
    history = [];
  }

  public function execute(message:Message):Bool
  {
    var msg = message.eval(this);
    trace(msg);
    history.push(msg);
    return msg.type() != "noRule";
  }

  public function eval(message:Message):Message
  {
    switch(message.type()) {
      case "noRule":
	return message;
      case "trigger":
	var t = new Message(message.tokens[1]);
	var r = new Message(message.tokens[2]);
	var i = message.tokens[3] == "true";
	var e = message.tokens[4] == "true";

	triggers.push(new Trigger(t, r, i, e));
        return Message.read("(addedTrigger ("+message.toString()+"))");
      default:
	var interrupt = false;
	var matched = triggers.filter(function(t) { return t.match(message); });

	for(trigger in matched) {
	  interrupt = interrupt || trigger.interrupt;
	  if(trigger.expire) {
	    triggers.remove(trigger);
	  }
	  execute(trigger.response);
	}

	if(interrupt) {
	  return Message.read("(interrupt ("+message.toString()+"))");
	}

	return game.eval(message);
    }
    return Message.read("(error)");
  }
}
