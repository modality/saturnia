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
    friendly.maxInventory = AugRandom.range(50, 101);
    friendly.refreshRate = AugRandom.range(25, 51);
    friendly.sellPrice = AugRandom.range(10, 31);
    friendly.buyPrice = AugRandom.range(20, 51);
    friendly.refreshTime = AugRandom.range(0, friendly.refreshRate);
    friendly.goodInventory = friendly.calcInventory();
    return friendly;
  }
}

