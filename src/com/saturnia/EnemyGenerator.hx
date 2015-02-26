package com.saturnia;

import com.modality.AugRandom;

class EnemyGenerator
{
  public static function generateEnemy(space:Space):PirateEncounter
  {
    var raider = new PirateEncounter(space);
    raider.name = AugRandom.sample(Generator.pirate_names, 1)[0];
    return raider;
  }
}
