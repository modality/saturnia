package com.saturnia;

import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.Grid;
import com.modality.ElasticGrid;
import com.modality.TextBase;
import com.modality.Controller;

import com.modality.cards.Invoker;
import com.modality.cards.Message;

class GameController extends Controller
{
  public var player:PlayerResources;
  public var grid:SpaceGrid;
  public var sectorType:SectorType;
  public var name:String;
  public var anyExplored:Bool;
  public var inCombat:Bool;
  public var inMerchant:Bool;
  public var regainFocus:Bool;
  public var sectorName:TextBase;

  public var canDragGrid:Bool;
  public var draggingGrid:Bool;
  public var mouseOffsetX:Int;
  public var mouseOffsetY:Int;
  public var sectorScrollX:Int;
  public var sectorScrollY:Int;
  
  public var invoker:Invoker;
  public var cgr:CardGameReceiver;

  public var combatPanel:CombatPanel;
  public var merchantPanel:MerchantPanel;

  public var nextExplore:NextExploreView;

  public function new()
  {
    super();
    player = new PlayerResources();
    sectorType = SectorType.Peaceful;
    anyExplored = false;
    inCombat = false;
    inMerchant = false;
    regainFocus = false;

    canDragGrid = false;
    draggingGrid = false;

    cgr = new CardGameReceiver(player.inv);
    invoker = new Invoker(cgr);

    add(player);

    sectorName = new TextBase();
    sectorName.size = Constants.FONT_SIZE_MD;
    sectorName.x = Constants.GRID_X;
    sectorName.y = 30;
    add(sectorName);

    startLevel();

    nextExplore = new NextExploreView();
    nextExplore.x = 700;
    nextExplore.y = 500;
    add(nextExplore);

    combatPanel = new CombatPanel(player, invoker, cgr);
    combatPanel.x = 0;
    combatPanel.y = 500;
    add(combatPanel);

    var panel:Base;
    var grayBg = new flash.display.BitmapData(1, 1, false, 0x111111);
    var img:Image;

    img = new Image(grayBg);
    img.scaleX = Constants.SCREEN_W;
    img.scaleY = Constants.GRID_Y;
    var panel = new Base(0, 0, img);
    panel.layer = Constants.MAP_PANEL_LAYER;
    add(panel);

    if(Constants.GRID_X > 0) {
      img = new Image(grayBg);
      img.scaleX = Constants.GRID_X;
      img.scaleY = Constants.GRID_H;
      var panel = new Base(0, Constants.GRID_Y, img);
      panel.layer = Constants.MAP_PANEL_LAYER;
      add(panel);
    }

    img = new Image(grayBg);
    img.scaleX = Constants.SCREEN_W - Constants.GRID_X - Constants.GRID_W;
    img.scaleY = Constants.GRID_H;
    var panel = new Base(Constants.GRID_X+Constants.GRID_W, Constants.GRID_Y, img);
    panel.layer = Constants.MAP_PANEL_LAYER;
    add(panel);

    img = new Image(grayBg);
    img.scaleX = Constants.SCREEN_W;
    img.scaleY = Constants.SCREEN_H - Constants.GRID_Y - Constants.GRID_H;
    var panel = new Base(0, Constants.GRID_Y+Constants.GRID_H, img);
    panel.layer = Constants.MAP_PANEL_LAYER;
    add(panel);
  }

  public override function update():Void
  {
    super.update();
    var mouse_x = Input.mouseX;
    var mouse_y = Input.mouseY;

    if(regainFocus || combatPanel.doingCardAction()) {
      regainFocus = false;
      return;
    }

    if(Input.mousePressed) {
      var gbg:Base = cast(collidePoint("grid_bg", mouse_x, mouse_y), Base);
      if(gbg != null) {
        mouseOffsetX = mouse_x;
        mouseOffsetY = mouse_y;
        canDragGrid = true;
        return;
      }
    } else if(Input.mouseDown) {
      sectorScrollX = mouse_x - mouseOffsetX; 
      sectorScrollY = mouse_y - mouseOffsetY; 

      if(canDragGrid && (draggingGrid || Math.sqrt(sectorScrollX*sectorScrollX + sectorScrollY*sectorScrollY) > 3)) {
        draggingGrid = true;
        grid.setOffset(sectorScrollX, sectorScrollY);
      }
    } else if(Input.mouseReleased && canDragGrid && draggingGrid) {
      grid.setOffset(sectorScrollX, sectorScrollY);
      sectorScrollX = 0;
      sectorScrollY = 0;

      grid.finishDrag();
      canDragGrid = false;
      draggingGrid = false;
      return;
    }

    if(!inCombat && !inMerchant) {
      if(Input.mouseReleased) {
        var gbg:Base = cast(collidePoint("grid_bg", mouse_x, mouse_y), Base);
        var marker:Base = cast(collidePoint("explorable", mouse_x, mouse_y), Base);
        if(gbg != null && marker != null) {
          var coord = grid.explore(marker, nextExplore.spaceType);

          var spaceStr = switch nextExplore.spaceType {
            case Voidness: "void";
            case Star(size, color): "star";
            case Planet(size, matter): "planet";
            case Debris(matter): "debris";
            case Hostile: "hostile";
            case Friendly: "friendly";
            case Faction(type): "faction";
            case SpaceStation(shape): "space_station";
          }
          invoker.execute(new Message(["explore", spaceStr, coord.x, coord.y]));
          nextExplore.getNextSpace();
          player.useFuel(1);
          player.updateGraphic();
          return;
        }

        var space:Space = cast(collidePoint("space", mouse_x, mouse_y), Space);
        if(space != null) {
          if(space.explored && space.spaceType == SpaceType.Friendly) {
            enterMerchant(space);
          }

          player.updateGraphic();
        }

        var btn:TextBase = cast(collidePoint("next_btn", mouse_x, mouse_y), TextBase);
        if(btn != null) {
          nextLevel();
        }

      }
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

    grid = new SpaceGrid(this);
    add(grid.grid_bg);
  }

  public function nextLevel():Void
  {
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
