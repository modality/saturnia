package com.saturnia;

import com.modality.Base;
import com.modality.cards.Message;

class ShipPart extends Base
{
  public static var UPDATED:String = "ship part updated";

  public var description:String;
  public var scienceCost:Int;
  public var cargoCost:Int;
  public var activeEffect:Bool;
  public var refreshRate:Int = 1;
  public var refreshLevels:Int = 1;
  public var soundEffect:String;
  public var effectName:String;
  public var effects:Message;

  public var refresh:Int = 0;
  public var refreshLevel:Int = 1;

  public var tapped:Bool = false;

  public function reset():Void
  {
    refresh = 0;
    refreshLevel = refreshLevels;
    tapped = false;
  }

  public function ready():Bool
  {
    return activeEffect && !tapped;
    //return activeEffect && refreshLevel > 0;
  }

  public function use():Void
  {
    if(!ready()) return;
    dispatchEvent(new EffectEvent(EffectEvent.APPLY, effects.get(refreshLevel-1)));
    tapped = true;
    //refresh = 0;
    //refreshLevel = 0;
    if(soundEffect != "") {
      SoundManager.play(soundEffect);
    }
    dispatchEvent(new ShipPartEvent(UPDATED, this));
  }

  public function pulse():Void
  {
    if(!activeEffect) return;
    if(refreshLevel < refreshLevels) {
      refresh++;
      if(refresh >= refreshRate) {
        refresh = 0;
        refreshLevel++;
        dispatchEvent(new ShipPartEvent(UPDATED, this));
      }
    }
  }
}

