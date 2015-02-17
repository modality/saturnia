package com.saturnia;

import com.modality.Base;
import com.modality.cards.Message;

class ShipPart extends Base implements Purchasable
{
  public static var UPDATED:String = "ship part updated";

  public var infinite:Bool = false;
  public var amount:Int = 1;
  public var level:Int;
  public var description:String;
  public var scienceCost:Int;
  public var cargoCost:Int;
  public var energyCost:Int;
  public var activeEffect:Bool;
  public var soundEffect:String;
  public var effectName:String;
  public var effect:Message;
  public var tapped:Bool = false;

  public function reset():Void
  {
    tapped = false;
  }

  public function ready():Bool
  {
    return activeEffect && !tapped;
  }

  public function use():Void
  {
    if(!ready()) return;
    dispatchEvent(new EffectEvent(EffectEvent.APPLY, effect));
    tapped = true;
    if(soundEffect != "") {
      SoundManager.play(soundEffect);
    }
    dispatchEvent(new ShipPartEvent(UPDATED, this));
  }

  public function singleUse():Bool
  {
    return true;
  }

  public function displayName():String
  {
    return name;
  }

  public function displayDescription():String
  {
    return description;
  }

  public function canPurchase(player:PlayerResources):Bool
  {
    return player.cargo >= cargoCost && player.science >= scienceCost;
  }

  public function onPurchase(event:PurchaseEvent):Void
  {
    event.player.cargo -= cargoCost;
    event.player.science -= scienceCost;
    event.player.addShipPart(this);
  }
}
