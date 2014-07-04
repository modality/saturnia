package com.saturnia;

import com.modality.AugRandom;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.TiledImage;

import com.saturnia.enums.StarSize;
import com.saturnia.enums.StarColor;
import com.saturnia.enums.PlanetSize;
import com.saturnia.enums.PlanetMatter;
import com.saturnia.enums.DebrisMatter;
import com.saturnia.enums.FactionType;
import com.saturnia.enums.StationShape;

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

  public static function randomSpace():SpaceType
  {
    return AugRandom.weightedChoice([
      SpaceType.Voidness => 20,
      randomStar() => 20,
      randomPlanet() => 20,
      randomDebris() => 20,
      SpaceType.Hostile => 10,
      SpaceType.Friendly => 10
    ]);
  }

  public static function randomPlanet():SpaceType
  {
    var size:PlanetSize = AugRandom.weightedChoice([
      PlanetSize.Terrestrial => 50,
      PlanetSize.Giant => 50
    ]);

    return switch(size) {
      case Terrestrial:
        Planet(size, AugRandom.weightedChoice([
          Iron => 20,
          Desert => 20,
          Carbon => 20,
          Ocean => 20,
          Ice => 20,
        ]));
      case Giant:
        Planet(size, AugRandom.weightedChoice([
          Hydrogen => 20,
          Helium => 20,
          Puffy => 20,
          Gas => 20,
          Ice => 20
        ]));
    };
  }

  public static function randomStar():SpaceType
  {
    var size:StarSize = AugRandom.weightedChoice([
      StarSize.Giant => 50,
      StarSize.Main => 50,
      StarSize.Dwarf => 50
    ]);

    return switch(size) {
      case Giant:
        Star(size, AugRandom.weightedChoice([
          Blue => 25,
          White => 25,
          Orange => 25,
          Red => 25
        ]));
      case Main:
        Star(size, AugRandom.weightedChoice([
          Blue => 25,
          White => 25,
          Yellow => 25,
          Orange => 25
        ]));
      case Dwarf:
        Star(size, AugRandom.weightedChoice([
          Red => 50,
          White => 50,
          Brown => 50
        ]));
    };
  }

  public static function randomDebris():SpaceType
  {
    return AugRandom.weightedChoice([
      Debris(Gas) => 50,
      Debris(Rock) => 50,
      Debris(Ice) => 50
    ]);
  }

  public static function randomSpaceStation():SpaceType
  {
    return SpaceStation(Sphere);
  }

  public static function spaceImage(spaceType:SpaceType):Image
  {
    return switch(spaceType) {
      case Voidness: Assets.getImage("space_void");

      case Star(size, color): starImage(size, color);
      case Planet(size, matter): planetImage(size, matter);
      case Debris(matter): debrisImage(matter);

      case Hostile: Assets.getImage("space_raider");
      case Friendly: Assets.getImage("space_merchant");
      case SpaceStation(shape): Assets.getImage("space_station");
      default: return null;
    };
  }

  public static function planetImage(size:PlanetSize, matter:PlanetMatter):TiledImage
  {
    var x_offset = switch(matter) {
      case Iron, Hydrogen: 0;
      case Desert, Helium: 100;
      case Carbon, Puffy: 200;
      case Ocean, Gas: 300;
      case Ice: 400;
    };
    var y_offset = switch(size) {
      case Terrestrial: 400;
      case Giant: 300;
    };
    return Assets.getSprite("space_tex", x_offset, y_offset, 100, 100);
  }

  public static function starImage(size:StarSize, color:StarColor):TiledImage
  {
    var x_offset = switch(color) {
      case Blue: 0;
      case White: 100;
      case Yellow: 200;
      case Orange, Brown: 300;
      case Red: 400;
    };
    var y_offset = switch(size) {
      case Giant: 0;
      case Main: 100;
      case Dwarf: 200;
    };
    return Assets.getSprite("space_tex", x_offset, y_offset, 100, 100);
  }

  public static function debrisImage(matter:DebrisMatter):Image
  {
    return switch(matter) {
      case Gas: Assets.getImage("space_debris_gas");
      case Rock: Assets.getImage("space_debris_rock");
      case Ice: Assets.getImage("space_debris_ice");
    };
  }
}

