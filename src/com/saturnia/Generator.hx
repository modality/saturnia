package com.saturnia;

import haxe.EnumTools;
import com.modality.AugRandom;

enum WeightSize {
  Yes;
  Maybe;
  Low;
  High;
  Wide;
}

class Generator
{
  public static var sector_types:Array<String> = ["Deep Core", "Core", "Inner Rim", "Outer Rim", "Unknown"];

  public static var good_1:Array<String> = ["Amusing", "Assorted", "Battle", "Black", "Blue", "Charm", "Crystal", "Data", "Delightful", "Dream", "Eyeball", "Fire", "Flat", "Flux", "Fungus", "Gas", "God", "Grow", "Guardian", "Harmony", "Holo", "Important", "Jeweled", "Laser", "Lovely", "Mineral", "Nutrient", "Parasitic", "Passion", "Phase", "Planetary", "Psychic", "Red", "Religious", "Screech", "Shimmer", "Singing", "Whining"];
  public static var good_2:Array<String> = ["Ales", "Babies", "Balls", "Baubles", "Beetles", "Bubbles", "Chews", "Cloth", "Cones", "Cubes", "Cylinders", "Devices", "Drones", "Eggs", "Enzymes", "Furs", "Gems", "Goos", "Grids", "Harps", "Inductors", "Isotopes", "Juices", "Jumpers", "Keys", "Knives", "Masks", "Orbs", "Pearls", "Pets", "Pods", "Probes", "Pumps", "Pyramids", "Rings", "Rods", "Secrets", "Slugs", "Spices", "Stones", "Tagines", "Tasties", "Teleporters", "Things", "Transmitters", "Vids"];

  public static var good_2_singular:Array<String> = ["Ale", "Baby", "Ball", "Bauble", "Beetle", "Bubble", "Chew", "Cloth", "Cone", "Cube", "Cylinder", "Device", "Drone", "Egg", "Enzyme", "Fur", "Gem", "Goo", "Grid", "Harp", "Inductor", "Isotope", "Juice", "Jumper", "Key", "Knife", "Mask", "Orb", "Pearl", "Pet", "Pod", "Probe", "Pump", "Pyramid", "Ring", "Rod", "Secret", "Slug", "Spice", "Stone", "Tagine", "Tasty", "Teleporter", "Thing", "Transmitter", "Vid"];

  public static var artifact:Array<String> = ["Dodecahedron", "Ellipsoid", "Hypercube", "Tesseract"];

  public static var planet_common:Array<String> = ["Rocky Planet", "Crater Planet", "Hot Planet", "Arid Planet", "Asteroid Belt", "Gas Giant", "Ring Giant", "Ice Planet", "Lava Planet", "Dwarf Planet", "Sea Planet"];
  public static var planet_rare:Array<String> = ["Crystal Planet", "Jungle World", "Spice World", "Ruined World", "Designer World", "Casino World", "Vacation World", "Galactic Bistro"];

  public static var star_common:Array<String> = ["Brown Dwarf", "Red Dwarf", "White Dwarf", "Yellow Star", "Blue Giant", "Red Giant"];
  public static var star_rare:Array<String> = ["Quasar", "Pulsar", "Magnetar", "Planetary Nebula", "Diffuse Nebula", "Exploded Nebula", "Supernova", "Protoplanetary Disk"];

  public static var sector_1:Array<String> = ["Aglaonike", "Alhazen", "Fazari", "Khwarizmi", "Biruni", "Khujandi", "Ptolemy", "Gautama", "Bhaskara", "Madhava", "Aryabhata", "Kepler", "Cassini", "Nebra", "Barnard", "Nabonassar", "Messier", "Verrier", "Brahmagupta", "Chandrasekhar", "Sagan", "Hypatia"];

  public static var sector_2:Array<String> = ["Expanse", "Rift", "Arm", "Belt", "Region", "Zone", "Field", "Triangle", "Reach", "Verge", "Cluster", "Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega"];


  public static var sectorNames:Array<String>;
  public static var itemNames:Array<String>;

  public static var tarotGraphics:Map<MajorArcana, String> = [
    TheFool => "tarot_0",
    TheMagician => "tarot_1",
    TheHighPriestess => "tarot_2",
    TheEmpress => "tarot_3",
    TheEmperor => "tarot_4",
    TheHierophant => "tarot_5"
  ];

  public static function init():Void
  {
    sectorNames = [];
    itemNames = [];
  }

  public static function generateGalaxy():Galaxy
  {
    var galaxy = new Galaxy();

    galaxy.cards = AugRandom.sample([for (k in tarotGraphics.keys()) k], 5);

    for(i in 0...5) {
      galaxy.goods.push(generateItem());
    }

    // choose locations for keys
    for(i in 2...galaxy.cards.length) {
      var valid = false;
      var pick1 = 0, pick2 = 0;
      
      while(!valid) {
        valid = true;
        pick1 = Std.random(i);
        pick2 = Std.random(i);

        if(pick1 == pick2) valid = false;
        if(pick1 != i-1 && pick2 != i-1) valid = false;
      }

      galaxy.cardLocations.push([pick1, pick2]);
    }

    // decorate sectors
    galaxy.sectors.init(function(i:Int, j:Int):Sector {
      var sector:Sector = new Sector();

      var goodsList = AugRandom.shuffle(galaxy.goods);
      sector.tarot_x = galaxy.cards[i];
      sector.tarot_y = galaxy.cards[j];
      if(i == j) {
        sector.level = 5;
      } else {
        sector.level = i > j ? i : j;
      }
      sector.goodsBought = goodsList.slice(0, 3);
      sector.goodsSold = goodsList.slice(3);

      return fillSector(sector);
    });

    galaxy.setupPlayer();
    return galaxy;
  }

  public static function fillSector(sector:Sector):Sector
  {
    var spaceTypes:Array<String> = ["Start", "Exit"];
    var sectorTypes = new Map<String, Int>();
    for(s in Data.sectors.all) {
      sectorTypes.set(s.id.toString(), s.weight);
    }
    var sectorType:String = AugRandom.weightedChoice(sectorTypes);
    var sectorData:Data.Sectors = Data.sectors.resolve(sectorType);

    var addSpaceType = function(type:String, num:Int):Void {
      for(times in 0...num) {
        spaceTypes.push(type);
      }
    }

    addSpaceType("Star", AugRandom.range(sectorData.star.low, sectorData.star.high+1));
    addSpaceType("Planet", AugRandom.range(sectorData.planet.low, sectorData.planet.high+1));
    addSpaceType("Friendly", AugRandom.range(sectorData.friendly.low, sectorData.friendly.high+1));
    addSpaceType("Hostile", AugRandom.range(sectorData.hostile.low, sectorData.hostile.high+1));
    addSpaceType("Debris", AugRandom.range(sectorData.debris.low, sectorData.debris.high+1));
    addSpaceType("Quest", AugRandom.range(sectorData.quest.low, sectorData.quest.high+1));
    addSpaceType("Anomaly", AugRandom.range(sectorData.anomaly.low, sectorData.anomaly.high+1));

    if(spaceTypes.length > 25) {
      trace("too many spaces generated for sector type "+sectorType);
    }

    while(spaceTypes.length < 25) {
      spaceTypes.push("Voidness");
    }

    spaceTypes = AugRandom.shuffle(spaceTypes.slice(0, 25));

    sector.spaces.init(function(i:Int, j:Int):Space {
      var space:Space = new Space();
      space.grid = sector.spaces;
      space.spaceType = EnumTools.createByName(SpaceType, spaceTypes.shift());
      space.x = Constants.GRID_X+(i*Constants.BLOCK_W);
      space.y = Constants.GRID_Y+(j*Constants.BLOCK_H);
      space = fillSpace(space, sector);
      return space;
    });
    sector.title = generateSectorName();
    sector.sectorType = EnumTools.createByName(SectorType, sectorType);

    return sector;
  }

  public static function fillSpace(space:Space, sector:Sector):Space
  {
    if(space.spaceType == Friendly) {
      space.encounter = generateMerchant(space, sector);
    } else if(space.spaceType == Hostile) {
      space.encounter = EnemyGenerator.generateEnemy(space, sector.level * 10);
    }
    return space;
  }

  public static function generateMerchant(space:Space, sector:Sector):MerchantEncounter
  {
    var merchant = new MerchantEncounter(space);
    merchant.goodBought = sector.goodsBought[Std.random(sector.goodsBought.length)];
    merchant.goodSold = sector.goodsSold[Std.random(sector.goodsSold.length)];
    merchant.maxInventory = AugRandom.range(50, 101);
    merchant.refreshRate = AugRandom.range(25, 51);
    merchant.sellRate = AugRandom.range(10, 31);
    merchant.buyRate = AugRandom.range(20, 51);
    merchant.refreshTime = AugRandom.range(0, merchant.refreshRate);
    merchant.goodInventory = merchant.calcInventory();
    return merchant;
  }

  public static function generateItem():String
  {
    var generatedName:Bool = false;
    var name:String = "";

    while(generatedName == false) {
      name = good_1[Std.random(good_1.length)] + " " + good_2[Std.random(good_2.length)];
      generatedName = true;
      for(sn in itemNames) {
        if(name == sn) {
          generatedName = false;
        }
      }
      if(generatedName) sectorNames.push(name);
    }

    return name;
  }


  public static function generateSectorName():String
  {
    var generatedName:Bool = false;
    var name:String = "";

    while(generatedName == false) {
      name = sector_1[Std.random(sector_1.length)] + " " + sector_2[Std.random(sector_2.length)];
      generatedName = true;
      for(sn in sectorNames) {
        if(name == sn) {
          generatedName = false;
        }
      }
      if(generatedName) sectorNames.push(name);
    }

    return name;
  }
}

