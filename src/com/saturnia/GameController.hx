package com.saturnia;

import openfl.events.Event;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Scene;
import com.modality.Grid;
import com.modality.Base;
import com.modality.TextBase;

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
  public var sector:Sector;
  public var grid:Grid<Space>;
  public var inMerchant:Bool;
  public var inNavigation:Bool;
  public var regainFocus:Bool;
  
  public var infoPanel:InfoPanel;
  public var friendlyPanel:Base;
  public var navigationPanel:NavigationPanel;
  public var powerPanel:PowerPanel;

  public function new()
  {
    super();
    inMerchant = false;
    inNavigation = false;
    regainFocus = false;

    regainFocus = false;

    galaxy = Generator.generateGalaxy();
    infoPanel = new InfoPanel(galaxy.player);
    powerPanel = new PowerPanel(galaxy);
    navigateTo(galaxy.getStartSector());

    galaxy.addEventListener(Galaxy.CYCLE, cycle);

    add(infoPanel);
    add(powerPanel);
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

      if(Input.released(Key.N)) {
        enterNavigation();
      }

      if(Input.mouseReleased) {
        if(space != null) {
          if(canExplore(space)) {
            space.explore();
            SoundManager.play("whoosh");
            galaxy.player.useFuel(1);
            var exploreEffects = [];
            switch(space.spaceType) {
              case Planet:
                exploreEffects = galaxy.player.getStatusEffects("onPlanet");
              case Star, Start:
                exploreEffects = galaxy.player.getStatusEffects("onStar");
              case Debris:
                exploreEffects = galaxy.player.getStatusEffects("onDebris");
              case Hostile:
                checkLocked();
                exploreEffects = galaxy.player.getStatusEffects("onHostile");
              case Engineer, Merchant, Military:
                exploreEffects = galaxy.player.getStatusEffects("onFriendly");
              case Hacker:
                exploreEffects = galaxy.player.getStatusEffects("onFriendly");
                galaxy.operatorsActive++;
              default:
            }

            var em = new EffectManager(this, galaxy);
            em.applyEffects(exploreEffects);
            infoPanel.updateGraphic();
            pulse();
          } else if(space.explored) {
            switch(space.spaceType) {
              case Engineer, Hacker, Merchant, Military:
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
      case Engineer: new EngineerPanel(space, galaxy);
      case Military: new MilitaryPanel(space, galaxy);
      case Merchant: new MerchantPanel(space, galaxy);
      case Hacker: new HackerPanel(space, galaxy);
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

  public function navigateTo(_sector:Sector):Void
  {
    if(navigationPanel != null) {
      exitNavigation();
    }
    if(grid != null) {
      grid.each(function(space:Space, i:Int, j:Int) {
        remove(space);
      });
    }

    sector = _sector;
    sector.explored = true;
    grid = sector.spaces;

    infoPanel.sector = sector;
    infoPanel.updateSectorGraphic();

    grid.each(function(space:Space, i:Int, j:Int) {
      space.updateGraphic();
      if(space.spaceType == Start && !space.explored) {
        space.spaceType = Star;
        space.explore();
      }
      add(space);
    });
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
    var canExploreNearPirate = galaxy.player.getStatusEffects("exploreNearPirates").length > 0;
    canExploreNearPirate = canExploreNearPirate || galaxy.policingContract > 0;
    grid.each(function(s:Space, i:Int, j:Int):Void {
      if(!s.explored) {
        s.locked = false;
        for(nayb in grid.neighbors(s, true)) {
          if(nayb.explored && (nayb.hasObject("pirate") && !canExploreNearPirate)) {
            s.locked = true; 
          }
        }
        s.updateGraphic();
      }
    });
  }

  public function canExplore(space:Space):Bool
  {
    if(space.explored) return false;
    if(space.locked) return false;

    var s:Space;

    s = grid.get(space.x_index-1, space.y_index);
    if(s != null && s.explored) return true;
    s = grid.get(space.x_index+1, space.y_index);
    if(s != null && s.explored) return true;
    s = grid.get(space.x_index, space.y_index-1);
    if(s != null && s.explored) return true;
    s = grid.get(space.x_index, space.y_index+1);
    if(s != null && s.explored) return true;

    return false;
  }

  public function pulse()
  {
    galaxy.pulse();
    powerPanel.pulse();
  }

  public function cycle(e:Event):Void
  {
    var piratesAttacked = false;
    var pirates:Array<PirateEncounter> = [];

    grid.each(function(space:Space, i:Int, j:Int):Void {
      if(space.explored && space.spaceType == Hostile) {
        if(space.encounter != null) {
          var pe:PirateEncounter = cast(space.encounter, PirateEncounter);
          if(!pe.stats.isDead()) {
            pirates.push(pe);
          }
        }
      /*
      } else if(space.spaceType == Friendly) {
        if(space.encounter != null) {
          cast(space.encounter, FriendlyEncounter).cycle();
        }
      */
      }
    });

    if(galaxy.policingContract == 0) {
      pirates.sort(function(a:PirateEncounter, b:PirateEncounter):Int {
        return b.stats.progInitiative - a.stats.progInitiative;
      });

      var evade = galaxy.player.progEvasion;
      for(pirate in pirates) {
        if(evade > 0) {
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
