package com.saturnia;

import com.modality.Base;
import com.modality.TextBase;

class NextTurnView extends Base
{
  public var turnCost:TextBase;
  public var inCombat:Bool;

  public function new()
  {
    super();
    turnCost = new TextBase();
    inCombat = false;

    addChild(turnCost);
    updateGraphic();
  }

  public override function updateGraphic():Void
  {
    super.updateGraphic();
    if(inCombat) {
      turnCost.text = "End Turn:\nEnemies attack";
    } else {
      turnCost.text = "End Turn:\n-5 fuel";
    }
  }
}

