package com.saturnia;

class MilitaryEncounter extends FriendlyEncounter
{
  public override function activate()
  {
    space.object = this;
  }
}


