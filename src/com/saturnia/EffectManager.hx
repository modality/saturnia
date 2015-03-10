package com.saturnia;

import com.modality.cards.Message;

class EffectManager
{
  public var game:GameController;
  public var galaxy:Galaxy;

  public function new(_game:GameController, _galaxy:Galaxy)
  {
    game = _game;
    galaxy = _galaxy;
  }

  public function applyEffects(effects:Array<Message>)
  {
    for(effect in effects) {
      applyEffect(effect);
    }
  }

  public function applyEffect(effect:Message, space:Space = null):Bool
  {
    //effect = effect.get(1);
    switch(effect.type()) {
      case "resource": 
        var resource = Std.string(effect.tokens[1]);
        var amount = 0;
        if(isVariable(Std.string(effect.tokens[2]))) {
          amount = getVariable(effect.tokens[2]);
        } else {
          amount = Std.int(effect.tokens[2]);
        }

        if(effect.tokens.length > 3) {
          amount *= Std.int(effect.tokens[3]);
        }

        if(galaxy.player.getResource(resource) + amount < 0) {
          return false;
        }

        galaxy.player.addResource(resource, amount);
        //infoPanel.gainResource(space, "fuel", effect.tokens[1]);
        return true;
      case "convert":
        var resourceA = Std.string(effect.tokens[1]),
            amountA = Std.int(effect.tokens[2]),
            resourceB = Std.string(effect.tokens[3]),
            amountB = Std.int(effect.tokens[4]);

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
          success = success && applyEffect(effect.get(index));
          index++;
        }
        return success;
      case "target":
        if(space == null) return false;

        switch [effect.tokens[1], space.spaceType, space.explored] {
          case ["unexplored", _, false],
               ["explored", _, true],
               ["star", Star, true],
               ["planet", Planet(_), true],
               ["friendly", Friendly(_), true],
               ["enemy", Hostile, true],
               ["rockDebris", Debris("rock"), true],
               ["iceDebris", Debris("ice"), true]:
            return applyEffect(effect.get(2));
          default:
            return false;
        }
      case "changeSpace":
        space.removeEncounter();
        switch(effect.tokens[1]) {
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
      // showType
      // solarSail
      // orbitalDefense
      // gravityRay
      // vultureBeam
    }
    return false;
  }

  public function isVariable(what:String) {
    return ["planetCount", "starCount", "debrisCount", "crewCount", "cycleProgress"].indexOf(what) != -1;
  }

  public function getVariable(what:String):Int
  {
    var sumTypes = function(spaceTypes:Array<SpaceType>):Int {
      var count = 0;
      game.grid.each(function(space:Space, i:Int, j:Int) {
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
