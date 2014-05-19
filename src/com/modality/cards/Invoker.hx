package com.modality.cards;

import com.modality.Message;

class Invoker {
  public var zones:Array<Zone>;
  public var rules:Array<Rule>; // specify what types of events are valid
  public var triggers:Array<Trigger>; // specify what happens when events are fired
  public var history:Array<Result>;

  public function new()
  {
    zones = [];
    rules = [];
    triggers = [];
    history = [];
  }

  public function createZone(_name:String):Zone
  {
    if(getZone(_name) == null) {
      var zone = new Zone(_name, this);
      zones.push(zone);
      return zone;
    } else {
      throw "Can't create zone with duplicate name!";
    }
  }

  public function getZone(_name:String):Zone
  {
    for(i in 0...zones.length) {
      if(zones[i].name == _name) {
        return zones[i];
      }
    }
    return null;
  }

  public function valid(message:Message):Bool
  {
    for(i in 0...rules.length) {
      if(rules[i].relevant(message) && rules[i].match(message)) {
        return true;
      }
    }
    return false;
  }

  public function execute(message:Message):Result
  {
    var result = new Result();

    if(valid(message)) {

    } else {
      result.message = "Event not valid";
    }
    return result;
  }
}
