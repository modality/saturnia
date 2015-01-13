package com.saturnia.ui;

import flash.display.BitmapData;
import com.haxepunk.graphics.Image;
import com.modality.Base;
import com.modality.TextBase;

class InfoPanel extends Base
{
  public var sector:Sector;
  public var player:PlayerResources;

  public var fuel_icon:Base;
  public var fuel_text:TextBase;
  public var fuel_bar:Base;
  public var shields_icon:Base;
  public var shields_text:TextBase;
  public var shields_bar:Base;
  public var cargo_icon:Base;
  public var cargo_text:TextBase;
  public var science_icon:Base;
  public var science_text:TextBase;

  public var enemy_text:TextBase;

  public var coffeeGfx:Base;
  public var sectorGfx:Base;
  public var sectorName:TextBase;

  public var cards:Array<Base>;

  public function new(_sector:Sector, _player:PlayerResources)
  {
    super(500, 0);

    sector = _sector;
    player = _player;

    cards = [for (c in player.cards) new Base(0, 0, Assets.getImage(Generator.tarotGraphics.get(c)))];

    var ci = 0;
    for(c in cards) {
      c.x = 0 + (ci * 40);
      c.y = 200 + Std.random(10);
      addChild(c);
      ci++;
    }

    var bmd:BitmapData;
    var img:Image;

    var fuel_y = 170;
    var shields_y = 150;
    var cargo_x = 250;
    var cargo_y = 100;
    var science_x = 250;
    var science_y = 125;

    sectorName = new TextBase();
    sectorName.x = Constants.GRID_X;
    sectorName.y = 0;
    sectorName.layer = Constants.MAP_LAYER;
    sectorName.text = sector.title;

    var sectorImg = switch(sector.sectorType) {
      case Peaceful: Assets.getImage("sector_system");
      case Nebula: Assets.getImage("sector_nebula");
      case Asteroid: Assets.getImage("sector_asteroid");
      case Anomaly: Assets.getImage("sector_anomaly");
    }

    sectorGfx = new Base(0, 0, sectorImg);
    
    var coffeeImg = Assets.getImage("ui_coffee");
    coffeeImg.scaleX = 0.5;
    coffeeImg.scaleY = 0.5;
    coffeeGfx = new Base(235, 182, coffeeImg);

    fuel_icon = new Base(0, fuel_y, Assets.getImage("icon_fuel"));
    fuel_text = new TextBase(25, fuel_y+1, 45, 20, player.fuel+"/"+player.maxFuel);
    fuel_icon.layer = Constants.RESOURCE_LAYER;
    fuel_text.layer = Constants.RESOURCE_LAYER;

    bmd = new BitmapData(1, 1, false, Constants.FUEL_COLOR);
    img = new Image(bmd);
    img.scaleX = 275;
    img.scaleY = 20;
    fuel_bar = new Base(25, fuel_y, img);

    shields_icon = new Base(0, shields_y, Assets.getImage("icon_shields"));
    shields_text = new TextBase(25, shields_y+1, 45, 20, player.shields+"/"+player.maxShields);
    shields_icon.layer = Constants.RESOURCE_LAYER;
    shields_text.layer = Constants.RESOURCE_LAYER;

    bmd = new BitmapData(1, 1, false, Constants.SHIELDS_COLOR);
    img = new Image(bmd);
    img.scaleX = 275;
    img.scaleY = 20;
    shields_bar = new Base(25, shields_y, img);

    cargo_icon = new Base(cargo_x, cargo_y, Assets.getImage("icon_cargo"));
    cargo_text = new TextBase(cargo_x + 25, cargo_y+1, 45, 20, ""+player.cargo);
    cargo_text.color = Constants.CARGO_COLOR;
    cargo_icon.layer = Constants.RESOURCE_LAYER;
    cargo_text.layer = Constants.RESOURCE_LAYER;

    science_icon = new Base(science_x, science_y, Assets.getImage("icon_science"));
    science_text = new TextBase(science_x + 25, science_y+1, 45, 20, ""+player.science);
    science_text.color = Constants.SCIENCE_COLOR;
    science_icon.layer = Constants.RESOURCE_LAYER;
    science_text.layer = Constants.RESOURCE_LAYER;

    enemy_text = new TextBase(0, 350, 300, 50, "");
    enemy_text.size = Constants.FONT_SIZE_XS;

    addChild(sectorGfx);
    addChild(sectorName);
    addChild(fuel_icon);
    addChild(fuel_bar);
    addChild(fuel_text);
    addChild(shields_icon);
    addChild(shields_bar);
    addChild(shields_text);
    addChild(cargo_icon);
    addChild(cargo_text);
    addChild(science_icon);
    addChild(science_text);
    addChild(enemy_text);

    addChild(coffeeGfx);
  }

  public function displayEnemy(pe:PirateEncounter)
  {
    var enemyInfo = "The \""+pe.name + "\"\n";

    enemyInfo += "HP: "+pe.stats.hitPoints+"/"+pe.stats.maxHitPoints+"\n";
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

    enemy_text.text = enemyInfo;
  }

  public function clearEnemy()
  {
    enemy_text.text = "";
  }

  public override function updateGraphic()
  {
    super.updateGraphic();
    fuel_text.text = player.fuel+"/"+player.maxFuel;
    cast(fuel_bar.graphic, Image).scaleX = Math.ceil(275. * player.fuel / player.maxFuel);
    shields_text.text = player.shields+"/"+player.maxShields;
    cast(shields_bar.graphic, Image).scaleX = Math.ceil(275. * player.shields / player.maxShields);
    cargo_text.text = ""+player.cargo;
    science_text.text = ""+player.science;
  }
}
