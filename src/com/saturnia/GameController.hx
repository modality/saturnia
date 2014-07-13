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

import com.saturnia.combat.CombatPanel;

import com.saturnia.inventory.Inventory;

class GameController extends Controller
{
  public var player:Inventory;
  public var inspector:Inspector;
  public var grid:SpaceGrid;
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

  public var combatPanel:CombatPanel;

  public var nextExplore:NextExploreView;
  public var nextTurn:NextTurnView;

  public function new()
  {
    super();
    player = new Inventory(Constants.STARTING_FUEL,
                           Constants.STARTING_SHIELDS,
                           Constants.STARTING_CARGO,
                           Constants.STARTING_SCIENCE);

    inspector = new Inspector(player);
    anyExplored = false;
    inCombat = false;
    regainFocus = false;

    canDragGrid = false;
    draggingGrid = false;

    invoker = new Invoker();

    add(inspector);

    startLevel();

    nextExplore = new NextExploreView();
    nextExplore.x = Constants.COMBAT_PANEL_X + 690;
    nextExplore.y = Constants.COMBAT_PANEL_Y;
    add(nextExplore);

    nextTurn = new NextTurnView();
    nextTurn.x = Constants.COMBAT_PANEL_X + 850;
    nextTurn.y = Constants.COMBAT_PANEL_Y;
    add(nextTurn);

    combatPanel = new CombatPanel(inspector, invoker);
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
    DC.registerObject(inspector, "inspector");
    haxe.Log.trace = GameController.newTrace;
  }

  public static function newTrace( v : Dynamic, ?inf : haxe.PosInfos ):Void
  {
    DC.log(v, 0xFFFFFF);
    /*
    if(inf != null) {
      DC.log(inf.className+"#"+inf.methodName+":"+inf.lineNumber, 0xCCCCCC);
    }
    */
  }

  public override function update():Void
  {
    inspector.setExplain("");
    super.update();
    var mouse_x = Input.mouseX;
    var mouse_y = Input.mouseY;

    if(regainFocus || combatPanel.doingCardAction()) {
      regainFocus = false;
      return;
    }

    var gbg:Base = cast(collidePoint("grid_bg", mouse_x, mouse_y), Base);

    if(!Input.mouseDown) {
      var space:Space = cast(collidePoint("space", mouse_x, mouse_y), Space);
      if(space != null && gbg != null) {
        inspector.setExplain(Generator.getExplainText(space.spaceType));
      }
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
        var marker:Base = cast(collidePoint("explorable", mouse_x, mouse_y), Base);
        var space:Space = cast(collidePoint("space", mouse_x, mouse_y), Space);

        if(gbg != null && marker != null) {
          var coord = grid.explore(marker, nextExplore.spaceType);
          var spaceStr = Generator.spaceString(nextExplore.spaceType);

          invoker.execute(new Message(["explore", spaceStr, coord.x, coord.y]));

          nextExplore.getNextSpace();
          player.useFuel(1);
          inspector.updateGraphic();
          return;
        } else if(gbg != null && space != null) {
          var spaceStr = Generator.spaceString(space.spaceType); 
          invoker.execute(new Message(["interact", spaceStr]));
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
    inspector.sectorName.text = name;

    grid = new SpaceGrid(this);
    add(grid.grid_bg);
  }
}
