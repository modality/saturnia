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

  public function applyEffect(effect:Message)
  {
    effect = effect.get(1);
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

        galaxy.player.addResource(resource, amount);
        //infoPanel.gainResource(space, "fuel", effect.tokens[1]);
    }
  }

  public function isVariable(what:String) {
    return ["planetCount", "starCount", "debrisCount", "crewCount", "cycleProgress"].indexOf(what) != -1;
  }

  public function getVariable(what:String):Int
  {
    var sumTypes = function(spaceType:SpaceType):Int {
      var count = 0;
      game.grid.each(function(space:Space, i:Int, j:Int) {
        if(space.explored && space.spaceType == spaceType) {
          count++;
        }
      });
      return count;
    };

    return switch(what) {
      case "planetCount": sumTypes(Planet);
      case "starCount": sumTypes(Star);
      case "debrisCount": sumTypes(Debris);
      case "enemyCount": sumTypes(Hostile);
      case "crewCount": galaxy.player.crewMembers.length;
      case "cycleProgress": galaxy.cycleCounter;
      default: 0;
    }
  }
}
