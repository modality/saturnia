package com.saturnia;

import com.haxepunk.utils.Input;
import com.haxepunk.Scene;
import com.modality.Grid;
import com.modality.TextBase;

class GameController extends Scene
{
  public var player:PlayerResources;
  public var tarot:TarotDeck;
  public var grid:Grid<Space>;
  public var sectorType:SectorType;
  public var name:String;
  public var anyExplored:Bool;
  public var inCombat:Bool;
  public var inMerchant:Bool;
  public var regainFocus:Bool;
  public var sectorName:TextBase;
  
  public var merchantPanel:MerchantPanel;

  public var nextBtn:TextBase;

  public function new()
  {
    super();
    player = new PlayerResources();
    tarot = new TarotDeck();
    sectorType = SectorType.Peaceful;
    anyExplored = false;
    inCombat = false;
    inMerchant = false;
    regainFocus = false;

    add(player);

    sectorName = new TextBase();
    sectorName.size = Constants.FONT_SIZE_MD;
    sectorName.x = Constants.GRID_X;
    sectorName.y = 30;
    add(sectorName);

    startLevel();

    nextBtn = new TextBase(60, 400, 10, 10, "Next Level >>");
    nextBtn.size = Constants.FONT_SIZE_MD;
    nextBtn.type = "next_btn";
  }

  public override function update():Void
  {
    super.update();
    if(regainFocus) {
      regainFocus = false;
      return;
    }
    if(!inCombat && !inMerchant) {
      if(Input.mouseReleased) {
        var mouse_x = Input.mouseX;
        var mouse_y = Input.mouseY;

        var space:Space = cast(collidePoint("space", mouse_x, mouse_y), Space);
        if(space != null) {
          if(canExplore(space)) {
            space.explore();
            player.useFuel(1);
            if(space.spaceType == SpaceType.Pirate) {
              checkLocked();
            }
          } else if(space.explored && space.spaceType == SpaceType.Pirate) {
            enterCombat(space);
          } else if(space.explored && space.spaceType == SpaceType.Merchant) {
            enterMerchant(space);
          }
        }

        var btn:TextBase = cast(collidePoint("next_btn", mouse_x, mouse_y), TextBase);
        if(btn != null) {
          nextLevel();
        }
      }
    }
  }

  public function enterCombat(space:Space):Void
  {
    inCombat = true;
  }

  public function exitCombat(space:Space):Void
  {
    inCombat = false;
    space.removeEncounter();
    checkLocked();
    regainFocus = true;

    var enemiesDestroyed = true;
    grid.each(function(space:Space, i:Int, j:Int) {
      if(space.hasObject("pirate") || (!space.explored && space.spaceType == SpaceType.Pirate)) {
        enemiesDestroyed = false;
      }
    });

    if(enemiesDestroyed) {
      add(nextBtn);
    }
  }

  public function enterMerchant(space:Space):Void
  {
    inMerchant = true;
    merchantPanel = new MerchantPanel(space, player);
    add(merchantPanel);
  }

  public function exitMerchant(space:Space, removeMerchant:Bool):Void
  {
    remove(merchantPanel);
    merchantPanel = null;
    inMerchant = false;
    if(removeMerchant) {
      space.removeEncounter();
    }
    regainFocus = true;
  }

  public function startLevel():Void
  {
    anyExplored = false;
    inCombat = false;
    regainFocus = false;

    name = Generator.generateSectorName();
    sectorName.text = name;

    var spaces:Array<Space> = Generator.generateSectorSpaces(sectorType);
    grid = new Grid<Space>(Constants.GRID_X, Constants.GRID_Y, Constants.GRID_W, Constants.GRID_H);
    grid.init(function(i:Int, j:Int):Space {
      var space:Space = spaces.shift();
      space.grid = grid;
      space.x = Constants.GRID_X+(i*Constants.BLOCK_W);
      space.y = Constants.GRID_Y+(j*Constants.BLOCK_H);
      space.updateGraphic();
      add(space);
      return space;
    });
    grid.each(function(space:Space, i:Int, j:Int) {
      space.grid = grid;
    });
  }

  public function nextLevel():Void
  {
    remove(nextBtn);
    grid.each(function(space:Space, i:Int, j:Int) {
      remove(space);
    });
    startLevel();
  }

  public function checkLocked():Void
  {
    grid.each(function(s:Space, i:Int, j:Int):Void {
      if(!s.explored) {
        s.locked = false;
        for(nayb in grid.neighbors(s, true)) {
          if(nayb.explored && nayb.hasObject("pirate")) {
            s.locked = true; 
          }
        }
        s.updateGraphic();
      }
    });
  }

  public function canExplore(space:Space):Bool
  {
    if(!anyExplored) {
      anyExplored = true;
      return true;
    }
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

}
