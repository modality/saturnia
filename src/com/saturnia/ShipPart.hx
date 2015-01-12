package com.saturnia;

import com.modality.Base;

class ShipPart extends Base
{
  public var description:String;
  public var scienceCost:Int;
  public var cargoCost:Int;

  public var refresh:Int = 0;
  public var refreshLevel:Int = 1;
  public var refreshRate:Int = 1;
  public var refreshMaxLevel:Int = 1;

  public function new(_name:String, _description:String, _sc:Int, _cc:Int)
  {
    super();
    name = _name;
    description = _description;
    scienceCost = _sc;
    cargoCost = _cc;
  }

  public function ready():Bool
  {
    return refreshLevel > 0;
  }

  public function use():Void
  {
    refresh = 0;
    refreshLevel = 0;
  }

  public function pulse():Void
  {
    if(refreshLevel < refreshMaxLevel) {
      refresh++;
      if(refresh >= refreshRate) {
        refresh = 0;
        refreshLevel++;
      }
    }
  }
}

