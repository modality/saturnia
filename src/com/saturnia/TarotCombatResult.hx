package com.saturnia;

class TarotCombatResult
{
  public var actionElement:String;
  public var reactionElement:String;
  public var resultElement:String;

  public var penaltyAmount:Int;
  public var rewardAmount:Int;

  public function new()
  {
    actionElement = "none";
    reactionElement = "none";
    resultElement = "none";
    penaltyAmount = 0;
    rewardAmount = 0;
  }

  public function actionText():String
  {
    return switch(actionElement) {
      case "air":
        "You maneuver deftly.";
      case "water":
        "You try to evade enemy attacks.";
      case "fire":
        "You attack fiercely.";
      case "earth":
        "You try to disable the enemy.";
      default:
        "You wait for the enemy to move.";
    }
  }

  public function reactionText():String
  {
    return switch(reactionElement) {
      case "air":
        "The enemy attack fries your\ncircuits.";
      case "water":
        "Your shields absorb the\nattack.";
      case "fire":
        "You consume extra fuel.";
      case "earth":
        "The enemy attack damages\nyour cargo.";
      default:
        "You resist enemy attacks.";
    }

  }

  public function penaltyText():String
  {
    return switch(reactionElement) {
      case "air":
        "-"+penaltyAmount+" science";
      case "water":
        "-"+penaltyAmount+" shields";
      case "fire":
        "-"+penaltyAmount+" fuel";
      case "earth":
        "-"+penaltyAmount+" cargo";
      default:
        "You resist enemy attacks.";
    }

  }

  public function penaltyColor():Int
  {
    return elementColor(reactionElement);
  }

  public function resultText():String
  {
    return switch(resultElement) {
      case "air":
        "You download data from the\nenemy.";
      case "water":
        "Your shields are recharged\nthrough EM resonance.";
      case "fire":
        "Your tractor beams capture\nfuel from the enemy.";
      case "earth":
        "Your tractor beams capture\ncargo from the enemy.";
      default:
        "You don't find anything.";
    }
  }

  public function rewardText():String
  {
    return switch(resultElement) {
      case "air":
        "+"+rewardAmount+" science";
      case "water":
        "+"+rewardAmount+" shields";
      case "fire":
        "+"+rewardAmount+" fuel";
      case "earth":
        "+"+rewardAmount+" cargo";
      default:
        "You don't find anything.";
    }
  }

  public function rewardColor():Int
  {
    return elementColor(resultElement);
  }

  public function elementColor(element:String):Int
  {
    return switch(element) {
      case "air":
        Constants.SCIENCE_COLOR;
      case "water":
        Constants.SHIELDS_COLOR;
      case "fire":
        Constants.FUEL_COLOR;
      case "earth":
        Constants.CARGO_COLOR;
      default:
        0xFFFFFF;
    }
  }
}
