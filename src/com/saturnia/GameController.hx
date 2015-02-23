package com.saturnia;

import openfl.events.Event;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Scene;
import com.modality.Grid;
import com.modality.TextBase;

import com.saturnia.ui.InfoPanel;
import com.saturnia.ui.MerchantPanel;
import com.saturnia.ui.HackerPanel;
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
  public var merchantPanel:MerchantPanel;
  public var hackerPanel:HackerPanel;
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
                galaxy.player.cargo += 1;
                galaxy.player.science += 1;
                exploreEffects = galaxy.player.stats.getStatusEffects("onPlanet");
              case Star, Start:
                galaxy.player.science += 2;
                exploreEffects = galaxy.player.stats.getStatusEffects("onStar");
              case Debris:
                galaxy.player.cargo += 2;
                exploreEffects = galaxy.player.stats.getStatusEffects("onDebris");
              case Hostile:
                checkLocked();
                exploreEffects = galaxy.player.stats.getStatusEffects("onHostile");
              case Friendly:
                exploreEffects = galaxy.player.stats.getStatusEffects("onFriendly");
              default:
            }

            var em = new EffectManager(this, galaxy);
            em.applyEffects(exploreEffects);
            infoPanel.updateGraphic();
            pulse();
          } else if(space.explored && space.spaceType == SpaceType.Friendly) {
            enterMerchant(space);
          } else if(space.explored && space.spaceType == SpaceType.Exit) {
            enterNavigation();
          } else if(space.explored && space.spaceType == SpaceType.Hostile) {
            playerAttacks(space);
            pulse();
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

  public function enterMerchant(space:Space):Void
  {
    inMerchant = true;
    merchantPanel = new MerchantPanel(space, galaxy.player);
    hackerPanel = new HackerPanel(space, galaxy);
    add(hackerPanel);
  }

  public function exitMerchant():Void
  {
    remove(hackerPanel);
    merchantPanel = null;
    hackerPanel = null;
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
      if(pe.stats.firstStrike) {
        galaxy.player.stats.takeDamage(pe.stats.attack());
        pe.stats.takeDamage(galaxy.player.stats.attack());
      } else {
        pe.stats.takeDamage(galaxy.player.stats.attack());
        if(!pe.stats.isDead()) {
          galaxy.player.stats.takeDamage(pe.stats.attack());
        }
      }

      galaxy.player.shields = galaxy.player.stats.hitPoints;
      galaxy.player.updated();
      if(pe.stats.isDead()) {
        space.removeEncounter();
        galaxy.player.cargo += pe.cargoReward;
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
    var canExploreNearPirate = galaxy.player.stats.getStatusEffects("exploreNearPirates").length > 0;
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
    grid.each(function(space:Space, i:Int, j:Int):Void {
      if(space.explored && space.spaceType == Hostile) {
        if(space.encounter != null) {
          var pe:PirateEncounter = cast(space.encounter, PirateEncounter);
          if(!pe.stats.isDead()) {
            piratesAttacked = true;
            galaxy.player.stats.takeDamage(pe.stats.attack());
          }
        }
      }
    });

    if(piratesAttacked) {
      galaxy.player.shields = galaxy.player.stats.hitPoints;
      galaxy.player.updated();
      SoundManager.play("hit"+Std.random(2));
    }
  }

}
