package com.modality.cards;

class Invoker {
  public var receivers:Array<Receiver>;
  public var triggers:Array<Trigger>; // specify what happens when events are fired
  public var history:Array<Message>;

  public function new()
  {
    receivers = [];
    triggers = [];
    history = [];
  }

  public function addReceiver(r:Receiver)
  {
    receivers.push(r);
  }

  public function execute(message:Message):Bool
  {
    var msgs:Array<Message> = eval(message);

    trace(message.toString());

    /*
    for(msg in msgs) {
      trace(">> "+msg.toString());
    }
    */

    msgs = msgs.filter(function(msg:Message):Bool {
      return msg.type() != "noRule";
    });

    if(msgs.length > 0) {
      history = history.concat(msgs);
      return true;
    }

    return false;
  }

  public function eval(message:Message):Array<Message>
  {
    switch(message.type()) {
      case "noRule":
        return [message];
      case "trigger":
        var t = new Message(message.tokens[1]);
        var r = new Message(message.tokens[2]);
        var i = message.tokens[3] == "true";
        var e = message.tokens[4] == "true";

        triggers.push(new Trigger(t, r, i, e));
        return [Message.read("(addedTrigger ("+message.toString()+"))")];
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
          return [Message.read("(interrupt ("+message.toString()+"))")];
        }

        var responses = [];
        for(receiver in receivers) {
          responses.push(receiver.eval(message));
        }
        return responses;
    }
    return [Message.read("(error)")];
  }
}
