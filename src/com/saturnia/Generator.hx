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
  public static var pirate_names:Array<String> = ["Hungry Hungry", "Men's Health", "Subprime Lender", "Cost Of Doing Business", "High Deductible", "Break Even", "Death and Gravity", "Dramatic Exit", "Ethics Gradient", "Honest Mistake", "Killing Time", "Lasting Damage", "Profit Margin", "Reasonable Excuse", "Trade Surplus", "Uninvited Guest", "Wit Amidst Folly", "Appropriate Measures", "Excessive Tolerance", "Frank Exchange of Ideas", "Vindictive Euphemism", "Polite Invitation", "Bad for Business", "Hidden Income", "Just Testing", "Lapsed Pacifist", "Insurance Claim", "Shrinkage", "Shoot Them Later", "So Much For Subtlety", "Somebody Else's Problem", "Steely Glint", "Unwitting Accomplice", "Youthful Indiscretion", "Forgetful", "Target Practice", "Uncertain Doom", "Second Guess", "Lower Your Shields", "Last Chance", "Breakneck Pace", "At All Cost", "Business End", "Shoots First", "Short End", "Cargo Liberator", "Cash Money", "Unfriendly", "Special Blend", "Stop Your Wailing", "Make Your Peace", "Wild Abandon", "Why Worry", "Better Luck Next Time", "Dumb Luck", "Meant Well", "Nevermore", "Bad News", "Why She Don't Write", "Inopportune Moment", "Iridium Blonde", "Imagine That", "Priceless Expression", "Dicey Odds", "New Economy", "Infringer", "Pot Luck", "One Too Many", "Bad Medicine", "Free Lunch", "Losing Bet", "Shakedown", "Sudden Movement", "Miranda Right", "Imaginative Name", "Stand and Deliver", "Long Walk, Short Airlock", "Despicable", "Oh No", "Baleful", "Unimaginable Delight", "Day Is Ours", "Better Than She Looks", "Relentless Apathy", "Lady Doth Protest", "Coming Right At Us", "End Of The Line", "Minor Anomaly", "Launch On Warning", "Collective Endeavor", "Bad Gravity", "Flux Capacitor", "Gray Area", "Inevitable", "Line Item Veto", "Inescapable Questioner", "Trade By Other Means", "Personal Growth Area", "Probable Cause", "Stop And Frisk", "Free Stress Test", "Incorrigible"];

  public static var sector_types:Array<String> = ["Deep Core", "Core", "Inner Rim", "Outer Rim", "Unknown"];

  public static var good_1:Array<String> = ["Amusing", "Assorted", "Battle", "Black", "Blue", "Bubbling", "Charm", "Crystal", "Data", "Delightful", "Dope", "Dream", "Eyeball", "Fire", "Flat", "Flux", "Fungus", "Gas", "God", "Grow", "Guardian", "Harmony", "Holo", "Important", "Jeweled", "Laser", "Lovely", "Mineral", "Nutrient", "Parasitic", "Passion", "Phase", "Planetary", "Psychic", "Red", "Religious", "Screech", "Shimmer", "Singing", "Whining"];
  public static var good_2:Array<String> = ["Ales", "Babies", "Balls", "Baubles", "Beetles", "Bubbles", "Chews", "Cloth", "Cones", "Cubes", "Cylinders", "Devices", "Drones", "Eggs", "Enzymes", "Furs", "Gems", "Goos", "Grids", "Harps", "Inductors", "Isotopes", "Juices", "Jumpers", "Keys", "Knives", "Masks", "Orbs", "Pearls", "Pets", "Pods", "Probes", "Pumps", "Pyramids", "Rings", "Rods", "Secrets", "Slugs", "Spices", "Stones", "Tagines", "Tasties", "Teleporters", "Things", "Transmitters", "Tureens", "Vids"];

  public static var good_2_singular:Array<String> = ["Ale", "Baby", "Ball", "Bauble", "Beetle", "Bubble", "Chew", "Cloth", "Cone", "Cube", "Cylinder", "Device", "Drone", "Egg", "Enzyme", "Fur", "Gem", "Goo", "Grid", "Harp", "Inductor", "Isotope", "Juice", "Jumper", "Key", "Knife", "Mask", "Orb", "Pearl", "Pet", "Pod", "Probe", "Pump", "Pyramid", "Ring", "Rod", "Secret", "Slug", "Spice", "Stone", "Tagine", "Tasty", "Teleporter", "Thing", "Transmitter", "Tureen", "Vid"];

  public static var artifact:Array<String> = ["Dodecahedron", "Ellipsoid", "Hypercube", "Tesseract"];

  public static var planet_common:Array<String> = ["Rocky Planet", "Crater Planet", "Hot Planet", "Arid Planet", "Asteroid Belt", "Gas Giant", "Ring Giant", "Ice Planet", "Lava Planet", "Dwarf Planet", "Sea Planet"];
  public static var planet_rare:Array<String> = ["Crystal Planet", "Jungle World", "Spice World", "Ruined World", "Designer World", "Casino World", "Vacation World", "Galactic Bistro"];

  public static var star_common:Array<String> = ["Brown Dwarf", "Red Dwarf", "White Dwarf", "Yellow Star", "Blue Giant", "Red Giant"];
  public static var star_rare:Array<String> = ["Quasar", "Pulsar", "Magnetar", "Planetary Nebula", "Diffuse Nebula", "Exploded Nebula", "Supernova", "Protoplanetary Disk"];

  public static var sector_1:Array<String> = ["Aglaonike", "Alhazen", "Fazari", "Khwarizmi", "Biruni", "Khujandi", "Ptolemy", "Gautama", "Bhaskara", "Madhava", "Aryabhata", "Kepler", "Cassini", "Nebra", "Barnard", "Nabonassar", "Messier", "Verrier", "Brahmagupta", "Chandrasekhar", "Sagan", "Hypatia"];

  public static var sector_2:Array<String> = ["Expanse", "Rift", "Arm", "Belt", "Region", "Zone", "Field", "Triangle", "Reach", "Verge", "Cluster", "Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega"];


  public static var sectorNames:Array<String>;
  public static var tradeGoods:Array<TradeGood>;

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
    tradeGoods = [];
  }

  public static function generateGalaxy():Galaxy
  {
    var galaxy = new Galaxy();

    galaxy.cards = AugRandom.sample([for (k in tarotGraphics.keys()) k], 5);

    for(i in 0...5) {
      galaxy.goods.push(generateTradeGood());
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

      galaxy.addEventListener(Galaxy.CYCLE, sector.cycle);
      sector.tarot_x = galaxy.cards[i];
      sector.tarot_y = galaxy.cards[j];
      if(i == j) {
        sector.level = 5;
      } else {
        sector.level = i > j ? i : j;
      }
      sector.goodsBought = goodsList.slice(0, 3);
      sector.goodsSold = goodsList.slice(3);

      return fillDebugSector(sector);
    });

    galaxy.setupPlayer();
    return galaxy;
  }

  public static function fillDebugSector(sector:Sector):Sector
  {
    var spaceTypes:Array<SpaceType> = [];
    
    spaceTypes.push(Start);
    spaceTypes.push(Friendly("merchant"));
    spaceTypes.push(Friendly("hacker"));
    spaceTypes.push(Friendly("military"));
    spaceTypes.push(Friendly("engineer"));
    spaceTypes.push(Exit);
    spaceTypes.push(Voidness);
    spaceTypes.push(Voidness);
    spaceTypes.push(Voidness);
    spaceTypes.push(Voidness);
    spaceTypes.push(Hostile);

    while(spaceTypes.length < 25) {
      spaceTypes.push(Voidness);
    }

    sector.spaces.init(function(i:Int, j:Int):Space {
      var space:Space = new Space();
      space.grid = sector.spaces;
      space.spaceType = spaceTypes.shift();
      space.x = Constants.GRID_X+(i*Constants.BLOCK_W);
      space.y = Constants.GRID_Y+(j*Constants.BLOCK_H);
      space = fillSpace(space, sector);
      return space;
    });

    sector.title = generateSectorName();
    sector.sectorType = SectorType.Debug;

    return sector;
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
    switch(space.spaceType) {
      case Friendly(type):
        switch(type) {
          case "hacker":
            space.encounter = FriendlyGenerator.generateHacker(space, sector);
          case "merchant":
            space.encounter = FriendlyGenerator.generateMerchant(space, sector);
          case "military":
            space.encounter = FriendlyGenerator.generateMilitary(space, sector);
          case "engineer":
            space.encounter = FriendlyGenerator.generateEngineer(space, sector);
        }
      case Hostile:
        space.encounter = EnemyGenerator.generateEnemy(space);
      default:
    }
    return space;
  }

  public static function generateTradeGood():TradeGood
  {
    var generatedName:Bool = false;
    var adj, sing, plur;
    var tradeGood:TradeGood = new TradeGood("", "", "");

    while(generatedName == false) {
      adj = good_1[Std.random(good_1.length)];

      var nounIndex = Std.random(good_2.length);

      plur = good_2[nounIndex];
      sing = good_2_singular[nounIndex];

      generatedName = true;
      for(tg in tradeGoods) {
        if(tg.adjective == adj || tg.singular == sing) {
          generatedName = false;
        }
      }

      tradeGood = new TradeGood(adj, sing, plur);
      tradeGoods.push(tradeGood);
    }

    return tradeGood;
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

