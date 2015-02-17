package com.saturnia;

import openfl.events.Event;

class PurchaseEvent extends Event
{
  public var player:PlayerResources;

  public function new(type:String, _player:PlayerResources)
  {
    super(type);
    player = _player;
  }
}

