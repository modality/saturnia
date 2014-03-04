package com.modality;

class AugRandom
{
  public static function weightedChoice<T>(weights:Map<T,Int>):T
  {
    var totalWeight:Int = 0;

    for(weight in weights) {
      totalWeight += weight;
    }

    var choice:Int = Std.random(totalWeight);
    var currentWeight:Int = 0;

    for(choiceName in weights.keys()) {
      currentWeight += weights[choiceName];
      if(choice < currentWeight) {
        return choiceName;
      }
    }

    return null;
  }

  public static function range(start:Int, end:Int):Int
  {
    return Std.random(end-start)+start;
  }

  public static function shuffle<T>(array:Array<T>):Array<T>
  {   
    var source:Array<T> = array.copy();
    var target:Array<T> = [];
    while(source.length > 0) {
      target.push(source.splice(range(0, source.length), 1)[0]);
    }
    return target;
  }

  public static function sample<T>(array:Array<T>, count:Int = 1):Array<T>
  {
    return shuffle(array).slice(0, count);
  }
}
