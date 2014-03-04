package com.saturnia;

import com.modality.AugRandom;

class Generator
{
  public static var sector_types:Array<String> = ["Deep Core", "Core", "Inner Rim", "Outer Rim", "Unknown"];

  public static var good_1:Array<String> = ["Amusing", "Assorted", "Battle", "Black", "Blue", "Charm", "Crystal", "Data", "Delightful", "Dream", "Eyeball", "Fire", "Flat", "Flux", "Fungus", "Gas", "God", "Grow", "Guardian", "Harmony", "Holo", "Important", "Jeweled", "Laser", "Lovely", "Mineral", "Nutrient", "Parasitic", "Passion", "Phase", "Planetary", "Psychic", "Red", "Screech", "Shimmer", "Singing", "Whining"];
  public static var good_2:Array<String> = ["Ales", "Babies", "Balls", "Baubles", "Beetles", "Bubbles", "Chews", "Cloth", "Cones", "Cubes", "Cylinders", "Devices", "Drones", "Eggs", "Enzymes", "Furs", "Gems", "Goos", "Grids", "Harps", "Inductors", "Isotopes", "Juices", "Jumpers", "Keys", "Masks", "Orbs", "Pearls", "Pets", "Pods", "Probes", "Pumps", "Pyramids", "Rings", "Rods", "Secrets", "Slugs", "Spices", "Stones", "Tagines", "Tasties", "Teleporters", "Things", "Transmitters", "Vids"];

  public static var good_2_singular:Array<String> = ["Ale", "Baby", "Ball", "Bauble", "Beetle", "Bubble", "Chew", "Cloth", "Cone", "Cube", "Cylinder", "Device", "Drone", "Egg", "Enzyme", "Fur", "Gem", "Goo", "Grid", "Harp", "Inductor", "Isotope", "Juice", "Jumper", "Key", "Mask", "Orb", "Pearl", "Pet", "Pod", "Probe", "Pump", "Pyramid", "Ring", "Rod", "Secret", "Slug", "Spice", "Stone", "Tagine", "Tasty", "Teleporter", "Thing", "Transmitter", "Vid"];

  public static var artifact:Array<String> = ["Dodecahedron", "Ellipsoid", "Hypercube", "Tesseract"];

  public static var planet_common:Array<String> = ["Rocky Planet", "Crater Planet", "Hot Planet", "Arid Planet", "Asteroid Belt", "Gas Giant", "Ring Giant", "Ice Planet", "Lava Planet", "Dwarf Planet", "Sea Planet"];
  public static var planet_rare:Array<String> = ["Crystal Planet", "Jungle World", "Spice World", "Ruined World", "Designer World", "Casino World", "Vacation World", "Galactic Bistro"];

  public static var star_common:Array<String> = ["Brown Dwarf", "Red Dwarf", "White Dwarf", "Yellow Star", "Blue Giant", "Red Giant"];
  public static var star_rare:Array<String> = ["Quasar", "Pulsar", "Magnetar", "Planetary Nebula", "Diffuse Nebula", "Exploded Nebula", "Supernova", "Protoplanetary Disk"];

  public static var sector_1:Array<String> = ["Aglaonike", "Alhazen", "Fazari", "Khwarizmi", "Biruni", "Khujandi", "Ptolemy", "Gautama", "Bhaskara", "Madhava", "Aryabhata", "Kepler", "Cassini", "Nebra", "Barnard", "Nabonassar", "Messier", "Verrier", "Chandrasekhar", "Sagan", "Hypatia"];
  public static var sector_2:Array<String> = ["Expanse", "Rift", "Arm", "Belt", "Region", "Zone", "Field", "Triangle", "Reach", "Verge", "Cluster", "Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega"];

  public static var sectorNames:Array<String>;

  public static function init():Void
  {
    sectorNames = new Array<String>();
  }

  public static function generateItem():String
  {
    return good_1[Std.random(good_1.length)] + " " + good_2[Std.random(good_2.length)];
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

  public static function generateSectorSpaces(sectorType:SectorType):Array<Space>
  {
    var spaces:Array<Space>;
    spaces = new Array<Space>();
    for(i in 0...(Constants.GRID_W * Constants.GRID_H)) {
      spaces.push(createSpace());
    }
    return spaces; 
  }

  public static function createSpace():Space
  {
    var space:Space = new Space();
    fillSpace(space);
    return space;
  }

  public static function fillSpace(space:Space)
  {
    space.spaceType = AugRandom.weightedChoice([
      SpaceType.Planet => 20,
      SpaceType.Star => 20,
      SpaceType.Pirate => 35,
      SpaceType.Voidness => 10,
      SpaceType.Merchant => 15
    ]);

    if(space.spaceType == SpaceType.Pirate) {
      space.encounter = new PirateEncounter(space);
    } else if(space.spaceType == SpaceType.Merchant) {
      space.encounter = new MerchantEncounter(space);
    }
  }
}

