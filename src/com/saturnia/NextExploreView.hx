package com.saturnia;

import com.modality.AugRandom;
import com.modality.Base;
import com.modality.TextBase;

class NextExploreView extends Base
{
  public var spaceType:SpaceType;

  public function new()
  {
    super();
    addChild(new TextBase(0, -20, 0, 0, "Next Tile:"));
    addChild(new TextBase(0, 70, 0, 0, "-1 Fuel"));
    getNextSpace();
  }

  public function getNextSpace():Void
  {
    spaceType = Generator.randomSpace();
    updateGraphic();
  }

  public override function updateGraphic():Void
  {
    super.updateGraphic();
    graphic = Generator.spaceImage(spaceType);
  }
}
