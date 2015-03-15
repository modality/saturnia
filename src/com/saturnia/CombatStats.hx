package com.saturnia;

import com.modality.AugRandom;
import com.modality.cards.Message;
import com.modality.Base;

class CombatStats extends Base
{
  public var statusEffects:Array<String>;

  public var hullPoints:Int = 1;
  public var maxHullPoints:Int = 1;

  // systems stats
  public var progInitiative:Int; // MOVE
  public var progEvasion:Int;    // EVAD
  public var progDamage:Int;     // LASR
  public var progShield:Int;     // SHLD

  public var shieldLevel:Int;
  public var stunned:Bool = false;

  public function new()
  {
    super();
    statusEffects = [];
    progInitiative = 1;
    progEvasion = 0;
    progDamage = 1;
    progShield = 0;

    shieldLevel = progShield;
  }

  public function pulse():Void
  {

  }

  public function cycle():Void
  {
    shieldLevel = progShield;
    stunned = false;
  }

  public function reset():Void {
    hullPoints = maxHullPoints;
  }

  public function isDead():Bool {
    return hullPoints == 0;
  }

  public function stun()
  {
    stunned = true;
  }

  public function addStatusEffect(effect:String)
  {
    if(!hasStatusEffect(effect)) {
      statusEffects.push(effect);
    }
  }

  public function hasStatusEffect(_effect:String):Bool
  {
    for(effect in statusEffects) {
      if(effect == _effect) return true;
    }
    return false;
  }

  public function removeStatusEffect(effect:String)
  {
    var i = statusEffects.length-1;
    while(i >= 0) {
      if(statusEffects[i] == effect) {
        statusEffects.splice(i, 1);
      }
      i--;
    }
  }

  public function attack():Array<CombatResult> {
    var attacks:Array<CombatResult> = [];

    var cr:CombatResult = new CombatResult();

    cr.hit = true;
    cr.damage = progDamage;
    if(hasStatusEffect("overdrive")) {
      cr.damage *= 2;
    }
    attacks.push(cr);

    return attacks;
  }

  public function takeDamage(crs:Array<CombatResult>):Void {
    for(cr in crs) {
      var damageTaken = cr.damage;

      if(shieldLevel > 0) {
        shieldLevel -= damageTaken;
        if(shieldLevel < 0) shieldLevel = 0;
      } else {
        hullPoints -= damageTaken;
        if(hullPoints < 0) hullPoints = 0;
      }
    }
  }
}
