package com.modality;

class Message {
  public var type:String;
  public var params:Map<String,String>;

  public static function newFromString(message_str:String):Message
  {
    var message = new Message();
    var typeMatch = ~/^([A-Za-z0-9_-]+) /;
    var bodyMatch = ~/([A-Za-z0-9_-]+: ?[^\s]+)/;

    if(typeMatch.match(message_str)) {
      message.type = StringTools.trim(typeMatch.matched(1));
      var body = typeMatch.matchedRight();

      while(bodyMatch.match(body)) {
        var arg = bodyMatch.matched(1);
        var tuple = arg.split(":");
        message.params.set(StringTools.trim(tuple[0]), StringTools.trim(tuple[1]));
        body = bodyMatch.matchedRight();
      }
    }

    return message;
  }

  public function new()
  {
    type = "";
    params = new Map<String,String>();
  }

  public function exists(key:String):Bool
  {
    return params.exists(key);
  }
  
  public function get(key:String):String
  {
    return params.get(key);
  }

  public function set(key:String, val:Dynamic):Void
  {
    params.set(key, Std.string(val));
  }

  public function remove(key:String):String
  {
    var val = params.get(key);
    params.remove(key);
    return val;
  }

  public function keys():Iterator<String>
  {
    return params.keys();
  }

  public function toString():String
  {
    var str;
    str = type;
    for(key in params.keys()) {
      str += " "+key+": "+params.get(key);
    }
    return str;
  }
}
