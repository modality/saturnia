package com.saturnia;

import com.modality.Base;

class TradeGood
{
  public var adjective:String;
  public var singular:String;
  public var plural:String;

  public function new(_adj:String, _sing:String, _plur:String)
  {
    adjective = _adj;
    singular = _sing;
    plural = _plur;
  }

  public function getFull(amount:Int):String {
    return amount == 1 ? fullSingle() : fullPlural();
  }

  public function fullPlural():String
  {
    return adjective + " " + plural;
  }

  public function fullSingle():String
  {
    return adjective + " " + singular;
  }

  public function getShort(amount:Int):String {
    return amount == 1 ? shortSingle() : shortPlural();
  }

  public function shortSingle():String
  {
    return singular;
  }

  public function shortPlural():String
  {
    return plural;
  }
}
