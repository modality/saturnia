package com.saturnia;

import com.modality.Base;
import com.modality.cards.Message;

class ShipPart
{
  public var name:String;
  public var description:String;
  public var scienceCost:Int;
  public var cargoCost:Int;
  public var activeEffect:Bool;
  public var refreshRate:Int = 1;
  public var refreshLevels:Int = 1;
  public var effects:Message;

  public var refresh:Int = 0;
  public var refreshLevel:Int = 1;

  public function new()
  {
  }

  public function reset():Void
  {
    refresh = 0;
    refreshLevel = refreshLevels;
  }

  public function ready():Bool
  {
    return activeEffect && refreshLevel > 0;
  }

  public function use():Void
  {
    if(!activeEffect) return;
    refresh = 0;
    refreshLevel = 0;
  }

  public function pulse():Void
  {
    if(!activeEffect) return;
    if(refreshLevel < refreshLevels) {
      refresh++;
      if(refresh >= refreshRate) {
        refresh = 0;
        refreshLevel++;
      }
    }
  }
}

