package com.saturnia;

import com.modality.AugRandom;

class EnemyGenerator
{
  public static var attacks:Map<String, Int> = [
    "basic" => 5,
    "energy" =>	10,
    "physical" => 10,
    "multi" => 10,
    "charge" => 20,
    "ordnance" => 20
  ];

  public static var attackBuffs:Map<String, Float> = [
    "stacking" => 0.2,
	  "double_attack" => 0.5,
	  "critical" => 0.1,
	  "hitrate100" => 0.2
  ];

  public static var attackDebuffs:Map<String, Float> = [
    "weak" => 0.1,
    "miss_chance" => 0.2
  ];

  public static var defenses:Map<String, Int> = [
    "nothing" => 0,
    "evade" => 5,
    "first_strike" => 5,
    "energy_shield" => 10,
    "mag_shield" => 10,
    "damage_reduction" => 15,
    "tank" => 15,
    "thorny" => 15
  ];

	public static var defenseBuffs:Map<String, Float> = [
	  "high_hp" => 0.3,
	  "resist_physical" => 0.3,
	  "resist_energy" => 0.3
	];

  public static var defenseDebuffs:Map<String, Float> = [
    "low_hp" => 0.3,
    "weak_physical" => 0.3,
    "weak_energy" => 0.4
	];

  public static var pirate_names:Array<String> = ["Hungry Hungry", "Men's Health", "Subprime Lender", "Cost Of Doing Business", "High Deductible", "Break Even", "Death and Gravity", "Dramatic Exit", "Ethics Gradient", "Honest Mistake", "Killing Time", "Lasting Damage", "Profit Margin", "Reasonable Excuse", "Trade Surplus", "Uninvited Guest", "Wit Amidst Folly", "Appropriate Measures", "Excessive Tolerance", "Frank Exchange of Ideas", "Vindictive Euphemism", "Polite Invitation", "Bad for Business", "Hidden Income", "Just Testing", "Lapsed Pacifist", "Insurance Claim", "Shrinkage", "Shoot Them Later", "So Much For Subtlety", "Somebody Else's Problem", "Steely Glint", "Unwitting Accomplice", "Youthful Indiscretion", "Forgetful", "Target Practice", "Uncertain Doom", "Second Guess", "Lower Your Shields", "Last Chance", "Breakneck Pace", "At All Cost", "Business End", "Shoots First", "Short End", "Cargo Liberator", "Cash Money", "Unfriendly", "Special Blend", "Stop Your Wailing", "Make Your Peace", "Wild Abandon", "Why Worry", "Better Luck Next Time", "Dumb Luck", "Meant Well", "Nevermore", "Bad News", "Why She Don't Write", "Inopportune Moment", "Iridium Blonde", "Imagine That", "Priceless Expression", "Dicey Odds", "New Economy", "Infringer", "Pot Luck", "One Too Many", "Bad Medicine", "Free Lunch", "Losing Bet", "Shakedown", "Sudden Movement", "Miranda Right", "Imaginative Name", "Stand and Deliver", "Long Walk, Short Airlock", "Despicable", "Oh No", "Baleful", "Unimaginable Delight", "Day Is Ours", "Better Than She Looks", "Relentless Apathy", "Lady Doth Protest", "Coming Right At Us", "End Of The Line", "Minor Anomaly", "Launch On Warning", "Collective Endeavor", "Bad Gravity", "Flux Capacitor", "Gray Area", "Inevitable", "Line Item Veto", "Inescapable Questioner", "Trade By Other Means", "Personal Growth Area", "Probable Cause", "Stop And Frisk", "Free Stress Test", "Incorrigible"];

  public static function generateEnemy(space:Space, target:Int):PirateEncounter
  {
    var raider = new PirateEncounter(space);
    raider.name = pirate_names[Std.random(pirate_names.length)];

    var powerList = buildPowerList(target);

    var s = raider.stats;

    for(p in powerList) {
      switch(p) {
        case "energy": s.attackType = AttackType.Energy;
        case "physical": s.attackType = AttackType.Physical;
        case "charge":
          s.attackType = AttackType.Energy;
          s.useCharge = true;
          s.attackPower *= 3;
        case "ordnance":
          s.attackType = AttackType.Physical;
          s.useAmmunition = true;
          s.attackPower = 5;
          s.maxAmmunition = 3;
        case "stacking":
          s.useStacking = true;
          s.stackingStep = 1;
        case "multi":
          s.numAttacks = 2;
          s.attackPower = Math.floor(s.attackPower / 2.);
        case "double_attack": s.numAttacks *= 2;
        case "critical": s.criticalChance = 20;
        case "hitrate100": s.alwaysHit = true;
        case "weak": s.attackPower = Math.floor(s.attackPower / 2.);
        case "miss_chance": s.accuracyRating = 70;
        case "evade": s.evadeChance = 20;
        case "first_strike": s.firstStrike = true;
        case "mag_shield": s.resistPhysical = 20;
        case "energy_shield": s.resistEnergy = 20;
        case "damage_reduction": s.damageReduction = 3;
        case "tank": s.maxHitPoints = 20;
        case "thorny": s.thornDamage = 3;
        case "high_hp": s.maxHitPoints = Math.ceil(s.maxHitPoints * 1.3);
        case "resist_physical": s.resistPhysical += 10;
        case "resist_energy": s.resistEnergy += 10;
        case "low_hp": s.maxHitPoints = Math.ceil(s.maxHitPoints * 0.7);
        case "weak_physical": s.resistPhysical -= 10;
        case "weak_energy": s.resistEnergy -= 10;
      }
    }

    if(s.attackPower < 1) s.attackPower = 1;
    s.reset();
    raider.description = buildDescription(raider);

    var reward = Std.random(4);
    switch(reward) {
      case 0: raider.cargoReward = Math.floor(target/2);
      case 1: raider.scienceReward = Math.floor(target/2);
      case 2: raider.fuelReward = Math.floor(target/3);
      case 4: raider.cargoReward = raider.scienceReward = Math.floor(target/3);
      default:
    }

    return raider;
  }

  public static function buildDescription(pe:PirateEncounter):String
  {
    var enemyInfo = "";
    enemyInfo += "Attack: "+(pe.stats.attackPower+pe.stats.stackingDamage)+"\n";
    if(pe.stats.numAttacks > 1) {
      enemyInfo += "Multi-Attack ("+pe.stats.numAttacks+")\n";
    }
    if(pe.stats.attackType == Energy) {
      enemyInfo += "Energy Attack\n";
    } else if(pe.stats.attackType == Physical) {
      enemyInfo += "Physical Attack\n";
    }
    if(pe.stats.useCharge) enemyInfo += "Charge Attack\n";
    if(pe.stats.useStacking) enemyInfo += "Stacking Attack ("+pe.stats.stackingStep+")\n";
    if(pe.stats.firstStrike) enemyInfo += "First Strike\n";
    if(pe.stats.alwaysHit) enemyInfo += "Always Hit\n";
    if(pe.stats.damageReduction > 0) enemyInfo += "Damage Reduction "+pe.stats.damageReduction+"\n";
    if(pe.stats.thornDamage > 0) enemyInfo += "Counter "+pe.stats.thornDamage+"\n";
    if(pe.stats.overloadRating > 0) enemyInfo += "Overload "+pe.stats.overloadRating+"\n";
    if(pe.stats.evadeChance > 0) enemyInfo += "Evasion "+pe.stats.evadeChance+"%\n";
    if(pe.stats.resistEnergy > 0) enemyInfo += "Resist Energy "+pe.stats.resistEnergy+"%\n";
    if(pe.stats.resistPhysical > 0) enemyInfo += "Resist Physical "+pe.stats.resistPhysical+"%\n";

    return enemyInfo;
  }

  public static function buildPowerList(target:Int):Array<String>
  {
    var tries:Int = 0;
    var closestScore:Float = -1;
    var closestPowerList:Array<String> = [];

    do {
      var powers:Array<String> = [];
      var score:Float;

      var attack = sampleKeys(attacks.keys());
      var defense = sampleKeys(defenses.keys());

      powers.push(attack);
      powers.push(defense);

      score = attacks.get(attack) + defenses.get(defense);

      if(score > target) {
        var debuff:String;
        if(Math.random() < 0.5) {
          debuff = sampleKeys(attackDebuffs.keys());
          score *= 1. - attackDebuffs.get(debuff);
        } else {
          debuff = sampleKeys(defenseDebuffs.keys());
          score *= 1. - defenseDebuffs.get(debuff);
        }
        powers.push(debuff);
      } else if(score < target) {
        var buff:String;
        if(Math.random() < 0.5) {
          buff = sampleKeys(attackBuffs.keys());
          score *= 1. + attackBuffs.get(buff);
        } else {
          buff = sampleKeys(defenseBuffs.keys());
          score *= 1. + defenseBuffs.get(buff);
        }
        powers.push(buff);
      }

      if(closestScore == -1) {
        closestScore = score;
        closestPowerList = powers.copy();
      } else {
        if(Math.abs(target - score) < Math.abs(target - closestScore)) {
          closestScore = score;
          closestPowerList = powers.copy();
        }
      }
      tries++;
    } while(tries < 20 && (closestScore < (target * 0.8) || closestScore > (target * 1.25)));

    return closestPowerList;
  }

  public static function sampleKeys(keys:Iterator<String>):String
  {
    var ka:Array<String> = [for (k in keys) k];
    return ka[Std.random(ka.length)];
  }
}
