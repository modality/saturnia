package com.saturnia;

import openfl.events.Event;

import pgr.dconsole.DC;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Scene;
import com.modality.Base;
import com.modality.TextBase;
import com.modality.cards.Message;

import com.saturnia.ui.MapPanel;
import com.saturnia.ui.InfoPanel;
import com.saturnia.ui.MerchantPanel;
import com.saturnia.ui.HackerPanel;
import com.saturnia.ui.MilitaryPanel;
import com.saturnia.ui.EngineerPanel;
import com.saturnia.ui.NavigationPanel;
import com.saturnia.ui.PowerPanel;
import com.saturnia.ui.PopupIcon;

class GameController extends Scene
{
  public var galaxy:Galaxy;
  public var inMerchant:Bool;
  public var inNavigation:Bool;
  public var regainFocus:Bool;
  
  public var mapPanel:MapPanel;
  public var infoPanel:InfoPanel;
  public var friendlyPanel:Base;
  public var navigationPanel:NavigationPanel;
  public var powerPanel:PowerPanel;
  public var effectManager:EffectManager;

  public function new()
  {
    super();
    inMerchant = false;
    inNavigation = false;
    regainFocus = false;


    galaxy = Generator.generateGalaxy();
    infoPanel = new InfoPanel(galaxy.player);
    powerPanel = new PowerPanel(this, galaxy);
    mapPanel = new MapPanel(galaxy);

    infoPanel.sector = mapPanel.sector;
    infoPanel.updateSectorGraphic();

    galaxy.addEventListener(Galaxy.CYCLE, cycle);

    add(mapPanel);
    add(infoPanel);
    add(powerPanel);

    DC.init();
    DC.registerObject(this, "game");
    DC.registerObject(galaxy, "galaxy");
    haxe.Log.trace = GameController.newTrace;
  }

  public static function newTrace(v:Dynamic, ?inf:haxe.PosInfos):Void
  {
    DC.log(v, 0xFFFFFF);
  }

  public override function update():Void
  {
    super.update();
    if(regainFocus) {
      regainFocus = false;
      return;
    }
    if(!inMerchant && !inNavigation) {
      var mouse_x = Input.mouseX;
      var mouse_y = Input.mouseY;
      var space:Space = cast(collidePoint("space", mouse_x, mouse_y), Space);

      if(Input.mouseReleased) {
        if(space != null) {
          if(effectManager != null) {
            effectManager.apply(space);
            effectManager = null;
          } else if(mapPanel.tryExplore(space)) {
            SoundManager.play("whoosh");
            galaxy.player.useFuel(1);
            switch(space.spaceType) {
              case Hostile:
                checkLocked();
              case Friendly(type):
                if(type == "hacker") {
                  galaxy.operatorsActive++;
                }
              default:
            }
            infoPanel.updateGraphic();
            pulse();
          } else if(space.explored) {
            switch(space.spaceType) {
              case Friendly(_):
                enterFriendly(space);
              case Exit:
                enterNavigation();
              case Hostile:
                playerAttacks(space);
                pulse();
              default:
            }
          }
        }
      } else {
        infoPanel.clearEnemy();
        if(space != null) {
          if(space.explored && space.spaceType == SpaceType.Hostile) {
            infoPanel.displayEnemy(cast(space.encounter, PirateEncounter));
          }
        }
      }
    }
  }

  public function enterFriendly(space:Space):Void
  {
    inMerchant = true;
    friendlyPanel = switch(space.spaceType) {
      case Friendly("engineer"): new EngineerPanel(space, galaxy);
      case Friendly("military"): new MilitaryPanel(space, galaxy);
      case Friendly("merchant"): new MerchantPanel(space, galaxy);
      case Friendly("hacker"): new HackerPanel(space, galaxy);
      default:
    }
    add(friendlyPanel);
  }

  public function exitFriendly():Void
  {
    remove(friendlyPanel);
    friendlyPanel = null;
    inMerchant = false;
    regainFocus = true;
  }

  public function enterNavigation():Void
  {
    inNavigation = true;
    navigationPanel = new NavigationPanel(galaxy);
    add(navigationPanel);
  }

  public function exitNavigation():Void
  {
    remove(navigationPanel);
    navigationPanel = null;
    inNavigation = false;
    regainFocus = true;
  }

  public function usePart(shipPart:ShipPart):Void
  {
    effectManager = new EffectManager(this, galaxy, shipPart.effect);
    if(!effectManager.targeted()) {
      effectManager.apply();
      effectManager = null;
    }
  }

  public function runEffect(message:String):Void
  {
    effectManager = new EffectManager(this, galaxy, Message.read(message));
    if(!effectManager.targeted()) {
      effectManager.apply();
      effectManager = null;
    }
  }

  public function playerAttacks(space:Space):Void
  {
    SoundManager.play("hit"+Std.random(2));
    if(space.encounter != null) {
      var pe:PirateEncounter = cast(space.encounter, PirateEncounter);
      if(pe.stats.progInitiative > galaxy.player.progInitiative) {
        galaxy.player.takeDamage(pe.stats.attack());
        pe.stats.takeDamage(galaxy.player.attack());
      } else {
        pe.stats.takeDamage(galaxy.player.attack());
        if(!pe.stats.isDead()) {
          galaxy.player.takeDamage(pe.stats.attack());
        }
      }

      galaxy.player.useFuel(1);
      galaxy.player.updated();
      if(pe.stats.isDead()) {
        space.removeEncounter();
        galaxy.player.science += pe.scienceReward;
        galaxy.player.fuel += pe.fuelReward;
        infoPanel.updateGraphic();
        SoundManager.playIn("destroy", 200);
        checkLocked();
      }
    }
  }

  public function checkLocked():Void
  {
    var canExploreNearPirate = galaxy.player.hasStatusEffect("exploreNearPirates");
    canExploreNearPirate = canExploreNearPirate || galaxy.policingContract > 0;
    mapPanel.checkLocked(canExploreNearPirate);
  }

  public function pulse()
  {
    galaxy.pulse();
    powerPanel.pulse();
  }

  public function cycle(e:Event):Void
  {
    var piratesAttacked = false;
    var pirates:Array<PirateEncounter> = mapPanel.getPirates();

    if(galaxy.policingContract == 0) {
      pirates.sort(function(a:PirateEncounter, b:PirateEncounter):Int {
        return b.stats.progInitiative - a.stats.progInitiative;
      });

      var evade = galaxy.player.progEvasion;
      for(pirate in pirates) {
        if(pirate.stats.stunned) {
          continue;
        } else if(evade > 0) {
          evade--;
        } else {
          piratesAttacked = true;
          galaxy.player.takeDamage(pirate.stats.attack());
        }
      }

      if(piratesAttacked) {
        galaxy.player.updated();
        SoundManager.play("hit"+Std.random(2));
      }
    }

    for(pirate in pirates) {
      pirate.stats.cycle();
    }
  }

}
