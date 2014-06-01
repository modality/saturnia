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
    spaceType = AugRandom.weightedChoice([
      SpaceType.Planet => 20,
      SpaceType.Star => 20,
      SpaceType.Pirate => 20,
      SpaceType.Voidness => 20,
      SpaceType.Merchant => 20
    ]);
    updateGraphic();
  }

  public function updateGraphic():Void
  {
    switch(spaceType) {
      case Star:
        graphic = Assets.getImage("space_star");
      case Planet:
        graphic = Assets.getImage("space_planet");
      case Pirate:
        graphic = Assets.getImage("space_raider");
      case Merchant:
        graphic = Assets.getImage("space_merchant");
      default:
        graphic = Assets.getImage("space_void");
    }
  }
}
