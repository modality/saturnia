package com.saturnia;

import pgr.dconsole.DC;
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
  public var regainFocus:Bool;

  public var canDragGrid:Bool;
  public var draggingGrid:Bool;
  public var mouseOffsetX:Int;
  public var mouseOffsetY:Int;
  public var sectorScrollX:Int;
  public var sectorScrollY:Int;
  
  public var invoker:Invoker;
  public var cgr:CardGameReceiver;

  public var combatPanel:CombatPanel;

  public var nextExplore:NextExploreView;

  public function new()
  {
    super();
    player = new PlayerResources();
    sectorType = SectorType.Peaceful;
    anyExplored = false;
    inCombat = false;
    regainFocus = false;

    canDragGrid = false;
    draggingGrid = false;

    cgr = new CardGameReceiver(player.inv);
    invoker = new Invoker(cgr);

    add(player);

    startLevel();

    nextExplore = new NextExploreView();
    nextExplore.x = Constants.COMBAT_PANEL_X + 700;
    nextExplore.y = Constants.COMBAT_PANEL_Y;
    add(nextExplore);

    combatPanel = new CombatPanel(player, invoker, cgr);
    combatPanel.x = Constants.COMBAT_PANEL_X;
    combatPanel.y = Constants.COMBAT_PANEL_Y;
    add(combatPanel);

    var panel:Base;
    var grayBg = new flash.display.BitmapData(1, 1, false, 0x111111);
    var img:Image;

    if(Constants.GRID_Y > 0) {
      img = new Image(grayBg);
      img.scaleX = Constants.SCREEN_W;
      img.scaleY = Constants.GRID_Y;
      var panel = new Base(0, 0, img);
      panel.layer = Constants.MAP_PANEL_LAYER;
      add(panel);
    }

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

    DC.init();
    DC.registerObject(combatPanel, "combatPanel");
    DC.registerObject(grid, "grid");
    DC.registerObject(player, "player");
  }

  public override function update():Void
  {
    player.setExplain("");
    super.update();
    var mouse_x = Input.mouseX;
    var mouse_y = Input.mouseY;

    if(regainFocus || combatPanel.doingCardAction()) {
      regainFocus = false;
      return;
    }

    var gbg:Base = cast(collidePoint("grid_bg", mouse_x, mouse_y), Base);
    var space:Space = cast(collidePoint("space", mouse_x, mouse_y), Space);
    if(space != null && gbg != null) {
      player.setExplain(space.getExplainText());
    }

    if(Input.mousePressed) {
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

    if(!inCombat) {
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
      }
    }
  }

  public function startLevel():Void
  {
    anyExplored = false;
    inCombat = false;
    regainFocus = false;

    name = Generator.generateSectorName();
    player.sectorName.text = name;

    grid = new SpaceGrid(this);
    add(grid.grid_bg);
  }
}
