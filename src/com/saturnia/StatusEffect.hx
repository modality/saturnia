package com.saturnia;

import com.modality.cards.Message;

class StatusEffect
{
  public var source:Dynamic;
  public var effect:Message;

  public function new(_effect:Message, _source:Dynamic)
  {
    effect = _effect;
    source = _source;
  }

  public function sameSource(test:Dynamic):Bool
  {
    return source = test;
  }

  public function isType(type:String)
  {
    if(effect.isMessage(0)) {
      for(i in 0...effect.tokens.length) {
        if(effect.get(i).type() == type) {
          return true;
        }
      }
    } else {
      return effect.type() == type;
    }
    return false;
  }

  public function getType(type:String):Array<Message>
  {
    var effects = [];

    if(effect.isMessage(0)) {
      for(i in 0...effect.tokens.length) {
        if(effect.get(i).type() == type) {
          effects.push(effect.get(i));
        }
      }
    } else {
      if(effect.type() == type) {
        effects.push(effect);
      }
    }
    return effects;
  }

  public static function fromCrewMember(crewMember:CrewMember):StatusEffect
  {
    return new StatusEffect(crewMember.effects, crewMember);
  }

  public static function fromShipPart(shipPart:ShipPart):StatusEffect
  {
    return new StatusEffect(shipPart.effects, shipPart);
  }
}
