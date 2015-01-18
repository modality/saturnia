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

  public var fuel_bar:ResourceBar;
  public var shields_bar:ResourceBar;
  public var cargo_counter:ResourceCounter;
  public var science_counter:ResourceCounter;

  public var enemy_text:TextBase;

  public var coffeeGfx:Base;
  public var sectorGfx:Base;
  public var sectorName:TextBase;

  public var shipParts:Array<ShipPartMenuItem>;

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

    shipParts = [];
    player.addEventListener(ShipPartEvent.ADD, addShipPart);
    player.addEventListener(PlayerResources.UPDATED, playerUpdated);
    for (sp in player.shipParts) {
      addShipPart(new ShipPartEvent(ShipPartEvent.ADD, sp));
    }

    var bmd:BitmapData;
    var img:Image;

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

    shields_bar = new ResourceBar(0, 150, "shields", Constants.SHIELDS_COLOR);
    fuel_bar = new ResourceBar(0, 170, "fuel", Constants.FUEL_COLOR);
    cargo_counter = new ResourceCounter(250, 100, "cargo");
    science_counter = new ResourceCounter(250, 125, "science");
    
    var coffeeImg = Assets.getImage("ui_coffee");
    coffeeImg.scaleX = 0.5;
    coffeeImg.scaleY = 0.5;
    coffeeGfx = new Base(235, 182, coffeeImg);
    coffeeGfx.layer = Constants.RESOURCE_LAYER;

    enemy_text = new TextBase(0, 350, 300, 50, "");
    enemy_text.size = Constants.FONT_SIZE_XS;

    addChild(sectorGfx);
    addChild(sectorName);
    addChild(fuel_bar);
    addChild(shields_bar);
    addChild(cargo_counter);
    addChild(science_counter);
    addChild(enemy_text);
    addChild(coffeeGfx);
    updateGraphic();
  }

  public override function update()
  {
    super.update();
    if(Input.mouseReleased) {
      var base:Base = cast(scene.collidePoint("ship_part_menu_item", Input.mouseX, Input.mouseY), Base);
      if(base != null) {
        base.dispatchEvent(new Event(ShipPartMenuItem.CLICKED));
      }
    }
  }

  public function gainResource(space:Space)
  {
    var start_x = space.x + Constants.BLOCK_W/2 - 10;
    var start_y = space.y + Constants.BLOCK_H/2 - 10;
    var science_end_x = science_counter.x;
    var science_end_y = science_counter.y;
    var cargo_end_x = cargo_counter.x;
    var cargo_end_y = cargo_counter.y;
    switch(space.spaceType) {
      case Planet:
        scene.add(new PickupParticle("science", this, start_x, start_y, science_end_x, science_end_y));
        scene.add(new PickupParticle("cargo", this, start_x, start_y, cargo_end_x, cargo_end_y));
      case Star, Start:
        scene.add(new PickupParticle("science", this, start_x, start_y, science_end_x, science_end_y));
        scene.add(new PickupParticle("science", this, start_x, start_y, science_end_x, science_end_y));
      case Debris:
        scene.add(new PickupParticle("cargo", this, start_x, start_y, cargo_end_x, cargo_end_y));
        scene.add(new PickupParticle("cargo", this, start_x, start_y, cargo_end_x, cargo_end_y));
      default:
    }
  }

  public function displayEnemy(pe:PirateEncounter)
  {
    enemy_text.text = pe.description;
  }

  public function clearEnemy()
  {
    enemy_text.text = "";
  }

  public function addShipPart(ev:ShipPartEvent):Void
  {
    var spmi:ShipPartMenuItem = new ShipPartMenuItem(0, 350 + shipParts.length * 40, ev.shipPart);
    shipParts.push(spmi);
    spmi.addEventListener(ShipPartEvent.TRY_USE, tryUseShipPart);
    addChild(spmi);
  }

  public function tryUseShipPart(ev:ShipPartEvent):Void
  {
    ev.shipPart.use();
  }

  public function playerUpdated(ev:Event):Void
  {
    updateGraphic();
  }

  public override function updateGraphic()
  {
    super.updateGraphic();
    fuel_bar.set(player.fuel, player.maxFuel);
    shields_bar.set(player.shields, player.maxShields);
    cargo_counter.set(player.cargo);
    science_counter.set(player.science);
  }
}
