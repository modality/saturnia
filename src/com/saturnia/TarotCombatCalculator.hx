package com.saturnia;

class TarotCombatCalculator
{
  public static function play(action:TarotCard, reaction:TarotCard, result:TarotCard):CombatResult
  {
    var combat_result = new CombatResult();

    var deltas:Array<Int> = [];
    deltas.push(Math.round(Math.abs(action.number - reaction.number)));
    deltas.push(Math.round(Math.abs(action.number - result.number)));
    deltas.push(Math.round(Math.abs(reaction.number - result.number)));

    deltas.sort(function(x:Int, y:Int):Int { return x-y; });

    var delta_1 = 0, delta_2 = 0;

    var element_1 = action.element;
    var element_2 = reaction.element;
    var element_3 = result.element;

    var elements = ["air", "water", "fire", "earth"];
    if(element_2 == "none") {
      if(element_3 == "none") {
        element_3 = elements.splice(Std.random(elements.length), 1)[0];
      }
      elements.remove(element_3);
      element_2 = elements.splice(Std.random(elements.length), 1)[0];
    } else if(element_3 == "none") {
      elements.remove(element_2);
      element_3 = elements.splice(Std.random(elements.length), 1)[0];
    }

    switch(element_1) {
      case "air":
        delta_1 = deltas[0] + deltas[1] + deltas[2];
        delta_2 = Std.random(delta_1 - 1) + 1;
        delta_1 = delta_1 - delta_2;
      case "water":
        delta_1 = deltas[0];
        delta_2 = deltas[1];
      case "fire":
        delta_1 = deltas[1];
        delta_2 = deltas[2];
      case "earth":
        delta_1 = Std.int((deltas[0] + deltas[2]) /2);
        delta_2 = delta_1;
      default:
        switch(Std.random(3)) {
          case 0:
            delta_1 = deltas[0] + deltas[1] + deltas[2];
            delta_2 = 0;
          case 1:
            delta_1 = 0;
            delta_2 = deltas[0] + deltas[1] + deltas[2];
          default:
            delta_1 = deltas.splice(Std.random(deltas.length), 1)[0] * 2;
            delta_2 = deltas.splice(Std.random(deltas.length), 1)[0] * 2;
        }
    }

    combat_result.actionElement = element_1;
    combat_result.reactionElement = element_2;
    combat_result.resultElement = element_3;
    combat_result.penaltyAmount = delta_1;
    combat_result.rewardAmount = delta_2;

    return combat_result;
  }
}
