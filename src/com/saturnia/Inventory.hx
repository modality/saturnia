package com.saturnia;

import flash.events.Event;
import com.modality.Base;

class Inventory extends Base
{
  public static var ZERO_FUEL:String = "zero fuel";
  public static var ZERO_SHIELDS:String = "zero shields";
  public static var TOOK_DAMAGE:String = "took damage";

  public var _fuel:Int;
  public var _shields:Int;
  public var _cargo:Int;
  public var _science:Int;
  public var fuel(get, set):Int;
  public var shields(get, set):Int;
  public var cargo(get, set):Int;
  public var science(get, set):Int;

  public var deck:Deck;

  public var items:Array<Item>;

  public function new(_fuel:Int, _shields:Int, _cargo:Int, _science:Int)
  {
    super();
    this._fuel = _fuel;
    this._shields = _shields;
    this._cargo = _cargo;
    this._science = _science;

    deck = new Deck();
    items = [];
  }

  public function get_fuel():Int
  {
    return this._fuel;
  }

  public function set_fuel(_fuel):Int
  {
    this._fuel = _fuel;
    if(this._fuel <= 0) {
      dispatchEvent(new Event(ZERO_FUEL));
      this._fuel = 0;
    }
    return this._fuel;
  }

  public function get_shields():Int
  {
    return this._shields;
  }

  public function set_shields(_shields):Int
  {
    if(_shields < this._shields) {
      dispatchEvent(new Event(TOOK_DAMAGE));
    }
    this._shields = _shields;
    if(this._shields <= 0) {
      dispatchEvent(new Event(ZERO_SHIELDS));
      this._shields = 0;
    }
    return this._shields;
  }

  public function get_cargo():Int
  {
    return this._cargo;
  }

  public function set_cargo(_cargo):Int
  {
    this._cargo = _cargo;
    return this._cargo;
  }

  public function get_science():Int
  {
    return this._science;
  }

  public function set_science(_science):Int
  {
    this._science = _science;
    return this._science;
  }
}
