package com.saturnia;

class HackerEncounter extends FriendlyEncounter
{
  public var initiativeTapped:Bool = false;
  public var evasionTapped:Bool = false;
  public var shieldTapped:Bool = false;
  public var damageTapped:Bool = false;


  public override function activate()
  {
    space.object = this;
  }

  public override function cycle():Void
  {
    initiativeTapped = false;
    evasionTapped = false;
    shieldTapped = false;
    damageTapped = false;
  }
}

