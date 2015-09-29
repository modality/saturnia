package com.saturnia.ui;

import openfl.events.Event;
import openfl.display.BitmapData;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.modality.Base;
import com.modality.TextBase;

class InfoPanel extends Base
{
  public var sector:Sector;
  public var player:PlayerResources;

  public var fuel_counter:ResourceCounter;
  public var science_counter:ResourceCounter;

  public var enemy_text:TextBase;

  public var coffeeGfx:Base;
  public var sectorGfx:Base;
  public var sectorName:TextBase;

  public function new(_player:PlayerResources)
  {
    super(500, 0);

    player = _player;

    player.addEventListener(PlayerResources.UPDATED, playerUpdated);

    var bmd:BitmapData;
    var img:Image;

    var cargo_x = 250;
    var cargo_y = 100;
    var science_x = 250;
    var science_y = 125;

    sectorName = new TextBase(Constants.GRID_X, 0, 0, 0, "");
    sectorName.layer = Constants.MAP_LAYER;
    sectorGfx = new Base(0, 0);

    fuel_counter = new ResourceCounter(0, 170, "fuel");
    science_counter = new ResourceCounter(250, 125, "science");
    
    var coffeeImg = Assets.getImage("ui_coffee");
    coffeeImg.scaleX = 0.5;
    coffeeImg.scaleY = 0.5;
    coffeeGfx = new Base(235, 182, coffeeImg);
    coffeeGfx.layer = Constants.RESOURCE_LAYER;

    enemy_text = new TextBase(0, 400, 300, 50, "");
    enemy_text.size = Constants.FONT_SIZE_XS;

    addChild(sectorGfx);
    addChild(sectorName);
    addChild(fuel_counter);
    addChild(science_counter);
    addChild(enemy_text);
    addChild(coffeeGfx);
    updateGraphic();
  }

  public function gainResource(space:Space, type:String, count:Int)
  {
    var start_x = space.x + Constants.BLOCK_W/2 - 10;
    var start_y = space.y + Constants.BLOCK_H/2 - 10;
    var end_x = 0.;
    var end_y = 0.;

    switch(type) {
      case "science":
        end_x = science_counter.x;
        end_y = science_counter.y;
      case "fuel":
        end_x = fuel_counter.x;
        end_y = fuel_counter.y;
      default:
    }

    for(i in 0...count) {
      scene.add(new PickupParticle(type, this, start_x, start_y, end_x, end_y));
    }
  }

  public function displayEnemy(pe:PirateEncounter)
  {
    var enemyInfo = "The \""+pe.name + "\"\n";
    enemyInfo += "HP: "+pe.stats.hullPoints+"/"+pe.stats.maxHullPoints+"\n";
    enemyInfo += pe.description;
    enemy_text.text = enemyInfo;
  }

  public function clearEnemy()
  {
    enemy_text.text = "";
  }

  public function playerUpdated(ev:Event):Void
  {
    updateGraphic();
  }

  public override function updateGraphic()
  {
    super.updateGraphic();
    fuel_counter.set(player.fuel);
    science_counter.set(player.science);
  }

  public function updateSectorGraphic()
  {
    /*
    sectorName.text = sector.title;

    var sectorImg = switch(sector.sectorType) {
      case Peaceful, Debug: Assets.getImage("sector_system");
      case Nebula: Assets.getImage("sector_nebula");
      case Asteroid: Assets.getImage("sector_asteroid");
      case Anomaly: Assets.getImage("sector_anomaly");
    }

    sectorGfx.image = sectorImg;
    */
  }
}
