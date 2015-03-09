package com.saturnia;

import com.modality.AugRandom;

class FriendlyGenerator
{
  public static function generateMilitary(space:Space, sector:Sector):MilitaryEncounter
  {
    var friendly = new MilitaryEncounter(space);
    friendly.level = sector.level;
    return friendly;
  }

  public static function generateHacker(space:Space, sector:Sector):HackerEncounter
  {
    var friendly = new HackerEncounter(space);
    friendly.level = sector.level;
    return friendly;
  }

  public static function generateEngineer(space:Space, sector:Sector):EngineerEncounter
  {
    var friendly = new EngineerEncounter(space);
    friendly.level = sector.level;
    friendly.parts = ShipPartManager.getParts(3, friendly.level);
    return friendly;
  }

  public static function generateMerchant(space:Space, sector:Sector):MerchantEncounter
  {
    var friendly = new MerchantEncounter(space);
    friendly.level = sector.level;
    friendly.goodBought = sector.goodsBought[Std.random(sector.goodsBought.length)];
    friendly.goodSold = sector.goodsSold[Std.random(sector.goodsSold.length)];
    return friendly;
  }
}
