package com.modality.cards;

class Message {
  public var tokens:Array<Dynamic>;

  public function new(_tokens:Array<Dynamic>)
  {
    tokens = _tokens;
  }

  public function type():String
  {
    return Std.string(tokens[0]);
  }

  public function toString():String
  {
    return Message.stringify(tokens);
  }

  // STATIC FUNCTIONS

  public static function stringify(array:Array<Dynamic>):String
  {
    var strArray:Array<String> = [];

    for(i in 0...array.length) {
      if(Std.is(array[i], Array)) {
        strArray.push(stringify(array[i]));
      } else {
        strArray.push(Std.string(array[i]));
      }
    }

    return "("+strArray.join(" ")+")";
  }

  public static function read(str:String):Message
  {
    return new Message(readFrom(tokenize(str)));
  }

  public static function tokenize(str:String):Array<String>
  {
    str = StringTools.replace(str, "(", " ( ");
    str = StringTools.replace(str, ")", " ) ");
    return str.split(" ").filter(function(a:String):Bool { return a.length > 0; });
  }

  public static function readFrom(tokens:Array<String>):Dynamic
  {
    if(tokens.length == 0) {
      throw "Syntax error: unexpected EOF while reading";
    }

    var token = tokens.shift();
    if(token == "(") {
      return list(tokens);
    } else if(token == ")") {
      throw "Syntax error: unexpected )";
    } else {
      return atom(token);
    }
  }

  public static function list(tokens:Array<String>):Array<Dynamic>
  {
    var l = [];
    while(tokens[0] != ")") {
      l.push(readFrom(tokens));
    }
    tokens.shift();
    return l;
  }

  public static function atom(token:String):Dynamic
  {
    var intRx = ~/^-?\d+$/;
    var floatRx = ~/^-?\d*\.\d+$/;

    if(intRx.match(token)) {
      return Std.parseInt(token);
    } else if(floatRx.match(token)) {
      return Std.parseFloat(token);
    } else if(token.toLowerCase() == "true") {
      return true;
    } else if(token.toLowerCase() == "false") {
      return false;
    }
    return token;
  }
}
