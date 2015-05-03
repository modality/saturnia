package com.saturnia;

import com.modality.AugRandom;

class MilitaryEncounter extends FriendlyEncounter
{
  public var contractFlatName:String;
  public var contractFlatRate:Int;
  public var contractFlatAmount:Int;
  public var contractEnemiesName:String;
  public var contractEnemiesAmount:Int;
  public var contractCycleName:String;
  public var contractCycleAmount:Int;
  public var contractRiskName:String;
  public var contractRiskAmount:Int;

  public var contractFull:Map<String, Int>;

  public static var contractTerms:Array<String> = [
    "Known knowns",
    "Unknown unknowns",
    "Base outlay",
    "Service charge",
    "Danger assessment",
    "Beeswax, official",
    "Room and board, beekeeper",
    "Mood lighting",
    "Minibar, organic",
    "Travel insurance, beehive",
    "Bee chow",
    "Hydroponic clover",
    "Hood ornament polish",
    "Depollenization process",
    "Anti-pirate ammunition",
    "Training video license",
    "Conscription fee",
    "Ointment, 64oz. tublet",
    "Printer ink",
    "Computer paper",
    "Dry cleaning fee",
    "Ceremonial orbs",
    "Side dishes",
  ];

  public override function activate()
  {
    cycle();
  }

  public override function cycle():Void
  {
    var contract = AugRandom.sample(contractTerms, 4);

    contractFull = new Map<String, Int>();
    contractFlatName = contract[0];
    contractEnemiesName = contract[1];
    contractCycleName = contract[2];
    contractRiskName = contract[3];

    contractFlatAmount = AugRandom.range(2, 5) * 5;
  }

  public function getFullContract(galaxy:Galaxy):Map<String, Int>
  {
    var enemyCount = 0;
    var exploredCount = 0;

    space.grid.each(function(s:Space, i:Int, j:Int) {
      if(s.explored) {
        exploredCount++;
        if(s.spaceType == Hostile) {
          enemyCount++;
        }
      }
    });

    contractEnemiesAmount = 3 * enemyCount;
    contractCycleAmount = (galaxy.cycleCounter - 2) * 2;
    contractRiskAmount = 20 - exploredCount;

    if(contractCycleAmount < 0) contractCycleAmount = 0;
    if(contractRiskAmount < 0) contractRiskAmount = 0;

    contractFull.set(contractEnemiesName, contractEnemiesAmount);
    contractFull.set(contractCycleName, contractCycleAmount);
    contractFull.set(contractRiskName, contractRiskAmount);

    return contractFull;
  }
}


