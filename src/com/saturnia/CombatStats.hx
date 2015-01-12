package com.saturnia;

import com.modality.AugRandom;

class CombatStats
{
  public var hitPoints:Int = 3;
  public var maxHitPoints:Int = 3;

  public var attackPower:Int = 1;
  public var attackType:AttackType = AttackType.Basic;
  public var numAttacks:Int = 1;

  public var useCharge:Bool = false;
  public var exhausted:Bool = false;

  public var useAmmunition:Bool = false;
  public var ammunition:Int = 0;
  public var maxAmmunition:Int = 0;

  public var useStacking:Bool = false;
  public var stackingDamage:Int = 0;
  public var stackingStep:Int = 0;

  public var firstStrike:Bool = false;
  public var strikeOnReveal:Bool = false;

  public var damageReduction:Int = 0;
  public var resistEnergy:Int = 0;
  public var resistPhysical:Int = 0;
  public var thornDamage:Int = 0;
  public var overloadRating:Int = 0;

  public var accuracyRating:Int = 90;
  public var evadeChance:Int = 0;
  public var criticalChance:Int = 10;
  public var alwaysHit:Bool = false;

  public function reset():Void {
    hitPoints = maxHitPoints;
    exhausted = false;
    ammunition = maxAmmunition;
    stackingDamage = 0;
  }

  public function isDead():Bool {
    return hitPoints == 0;
  }
  
  public function attack():Array<CombatResult> {
    var attacks:Array<CombatResult> = [];

    if(useCharge && exhausted) {
      exhausted = false;
      return attacks;
    }

    for(times in 0...numAttacks) {
      if(useAmmunition) {
        if(ammunition > 0) {
          ammunition--;
        } else {
          continue;
        }
      }

      var cr:CombatResult = new CombatResult();

      cr.hit = alwaysHit || AugRandom.range(0, 100) < accuracyRating;
      cr.critical = AugRandom.range(0, 100) < criticalChance;
      cr.damage = attackPower + (useStacking ? stackingDamage : 0);
      if(cr.critical) cr.damage = cr.damage * 2;
      cr.forcedHit = alwaysHit || cr.critical;
      cr.attackType = attackType;

      attacks.push(cr);
    }

    if(useStacking) {
      stackingDamage += stackingStep;
    }

    return attacks;
  }

  public function takeDamage(crs:Array<CombatResult>):Void {
    for(cr in crs) {
      if(!cr.forcedHit) {
        if(AugRandom.range(0, 100) < evadeChance) {
          continue;
        }
      }
      
      var damageTaken = cr.damage;

      damageTaken -= damageReduction;

      if(cr.attackType == AttackType.Energy && resistEnergy > 0) {
        damageTaken = Math.ceil(damageTaken * (100. - resistEnergy) / 100.);
      }

      if(cr.attackType == AttackType.Physical && resistPhysical > 0) {
        damageTaken = Math.ceil(damageTaken * (100. - resistPhysical) / 100.);
      }

      if(damageTaken > 0) {
        hitPoints -= damageTaken;
        if(hitPoints < 0) hitPoints = 0;
      }
    }
  }
}
