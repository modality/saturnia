package com.saturnia;

import flash.display.BitmapData;
import com.haxepunk.graphics.Emitter;
import com.modality.Base;

class PirateEncounter extends Encounter
{
  
  public var emitter:Emitter;
  public var emitter_entity:Base;

  public function new(_space:Space)
  {
    super(_space);
    type = "pirate";
    graphic = Assets.getImage("space_raider");
    inventory.addEventListener(Inventory.ZERO_SHIELDS, destroyed);
    inventory.addEventListener(Inventory.TOOK_DAMAGE, damaged);

    var bmd:BitmapData = new BitmapData(5, 5, false, 0xFFFFFF);
    emitter = new Emitter(bmd, 5, 5);
    emitter.newType("damage", [0]);
    emitter.setAlpha("damage", 1, 0.5);
    emitter.setColor("damage", 0xFFFF00, 0xCC0000);
    emitter.setMotion("damage", 0, 20, 0.2, 360, 10, 0.2);

    emitter.newType("smoke", [0]);
    emitter.setAlpha("smoke", 1, 0.8);
    emitter.setColor("smoke", 0xFFFFFF, 0x666666);
    emitter.setMotion("smoke", 0, 10, 0.3, 360, 5, 0.3);
    emitter_entity = new Base(0, 0, emitter);
    addChild(emitter_entity);
  }

  public override function activate()
  {
    space.object = this;
  }

  public function destroyed(e:Dynamic):Void
  {
  }

  public function damaged(e:Dynamic):Void
  {
    for(i in 0...10) {
      emitter.emit("smoke", 31, 30);
      emitter.emit("damage", 31, 30);
    }
  }

}
