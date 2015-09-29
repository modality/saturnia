package com.saturnia;

import com.modality.cards.Message;

class EffectManager
{
  public var game:GameController;
  public var galaxy:Galaxy;
  public var effect:Message;

  public function new(_game:GameController, _galaxy:Galaxy, _effect:Message)
  {
    game = _game;
    galaxy = _galaxy;
    effect = _effect;
  }

  public function targeted():Bool
  {
    return effect.type() == "target";
  }

  public function apply(space:Space = null):Bool
  {
    return applyEffect(effect, space);
  }

  public function applyEffect(effect:Message, space:Space = null):Bool
  {
    switch(effect.type()) {
      case "resource": 
        var resource = effect.getString(1);
        var amount = 0;
        if(isVariable(effect.getString(2))) {
          amount = getVariable(effect.getString(2));
        } else {
          amount = effect.getInt(2);
        }

        if(effect.tokens.length > 3) {
          amount *= effect.getInt(3);
        }

        if(galaxy.player.getResource(resource) + amount < 0) {
          return false;
        }

        galaxy.player.addResource(resource, amount);
        //infoPanel.gainResource(space, "fuel", effect.tokens[1]);
        return true;
      case "convert":
        var resourceA = effect.getString(1),
            amountA = effect.getInt(2),
            resourceB = effect.getString(3),
            amountB = effect.getInt(4);

        if(galaxy.player.getResource(resourceA) >= amountA) {
          galaxy.player.addResource(resourceA, -amountA);
          galaxy.player.addResource(resourceB, -amountB);
          return true;
        } else {
          return false;
        }
      case "multi":
        var index = 1;
        var success = true;
        while(index < effect.tokens.length && success) {
          success = success && applyEffect(effect.getMessage(index), space);
          index++;
        }
        return success;
      case "target":
        if(space == null) return false;

        if(matchSpace(effect.getString(1), space)) {
          return applyEffect(effect.getMessage(2), space);
        } else {
          return false;
        }
      case "changeSpace":
        space.removeEncounter();
        switch(effect.getString(1)) {
          case "void":
            space.spaceType = Voidness;
            space.updateGraphic();
          case "rockDebris":
            space.spaceType = Debris("rock");
            space.updateGraphic();
          case "iceDebris":
            space.spaceType = Debris("ice");
            space.updateGraphic();
        }
      case "stun":
        var pirate = cast(space.encounter, PirateEncounter);
        pirate.stats.stun();
      case "resetCycleProgress":
        galaxy.resetCycleProgress();
        game.powerPanel.pulse();
      case "overdrive":
        galaxy.player.addStatusEffect("overdrive");
      case "showType":
        var type = "all";
        if(effect.tokens.length > 1) {
          type = effect.getString(1);
        }

        if(space != null) {
          if(space.typeRevealed) return false;
          if(space.explored) return false;
          if(matchSpace(type, space)) {
            space.revealType();
          }
        } else {
          galaxy.grid.spaces.each(function(s:Space, x:Int, y:Int):Void {
            if(matchSpace(type, s)) {
              s.revealType();
            }
          });
        }
      case "solarSail":
        galaxy.grid.spaces.each(function(s:Space, x:Int, y:Int):Void {
          if(x == space.x_index || y == space.y_index) {
            s.explore();
          }
        });
      case "orbitalDefense":
        var naybs:Array<Space> = galaxy.grid.spaces.neighbors(space, false);
        for(nayb in naybs) {
          if(matchSpace("hostile", nayb)) {
            nayb.removeEncounter();
          }
        }
      case "vultureBeam":
        var pirate = cast(space.encounter, PirateEncounter);
        pirate.scienceReward *= 2;
        pirate.fuelReward *= 2;
      // gravityRay
    }
    return false;
  }

  public function matchSpace(str:String, space:Space):Bool
  {
    switch [str, space.spaceType, space.explored] {
      case ["all", _, _],
           ["unexplored", _, false],
           ["explored", _, true],
           ["star", Star, true],
           ["planet", Planet(_), true],
           ["friendly", Friendly(_), true],
           ["hostile", Hostile, true],
           ["rockDebris", Debris("rock"), true],
           ["iceDebris", Debris("ice"), true]:
        return true;
      default:
        return false;
    }
  }

  public function isVariable(what:String) {
    return ["planetCount", "starCount", "debrisCount", "crewCount", "cycleProgress"].indexOf(what) != -1;
  }

  public function getVariable(what:String):Int
  {
    var sumTypes = function(spaceTypes:Array<SpaceType>):Int {
      var count = 0;
      galaxy.grid.spaces.each(function(space:Space, i:Int, j:Int) {
        for(spaceType in spaceTypes) {
          if(space.explored && space.spaceType == spaceType) {
            count++;
          }
        }
      });
      return count;
    };

    return switch(what) {
      case "planetCount": sumTypes([Planet("dead"), Planet("live"), Planet("moon")]);
      case "starCount": sumTypes([Star]);
      case "debrisCount": sumTypes([Debris("rock"), Debris("ice")]);
      case "enemyCount": sumTypes([Hostile]);
      case "crewCount": galaxy.player.crewMembers.length;
      case "cycleProgress": galaxy.cycleCounter;
      default: 0;
    }
  }
}
