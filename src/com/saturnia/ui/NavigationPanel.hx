package com.saturnia.ui;

import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;

class NavigationPanel extends Base
{
  public var galaxy:Galaxy;
  public var go_btn:TextBase;
  public var cancel_btn:TextBase;
  public var cards:Map<Base, MajorArcana>;
  public var tarot_x:MajorArcana;
  public var tarot_y:MajorArcana;
  public var sector_name:TextBase;
  public var sector_type:TextBase;

  public function new(_galaxy:Galaxy)
  {
    super(50, 50);
    galaxy = _galaxy;

    var modal = Assets.getImage("ui_modal");
    modal.scaleX = 700;
    modal.scaleY = 500;
    this.graphic = modal;
    this.layer = Constants.OVERLAY_LAYER;

    var tb:TextBase;

    tb = new TextBase(10, 20, 300, 50, "Navigation");
    tb.size = Constants.FONT_SIZE_MD;
    addChild(tb);
    
    addChild(new TextBase(10, 225, 50, 50, "X:"));
    addChild(new TextBase(160, 225, 50, 50, "Y:"));

    sector_name = new TextBase(10, 375, 50, 50, "Sector Name:");
    sector_type = new TextBase(10, 400, 50, 50, "Sector Type:");
    addChild(sector_name);
    addChild(sector_type);

    cancel_btn = new TextBase(200, 450, 50, 50, "CANCEL");
    cancel_btn.type = "cancel_btn";
    cancel_btn.size = Constants.FONT_SIZE_MD;

    go_btn = new TextBase(100, 450, 50, 50, "GO");
    go_btn.type = "go_btn";
    go_btn.size = Constants.FONT_SIZE_MD;

    cards = new Map<Base, MajorArcana>();

    var ci = 0;
    for(card in galaxy.player.cards) {
      var base = new Base(0, 0, Assets.getImage(Generator.tarotGraphics.get(card)));
      base.type = "tarot_card";
      base.x = 40 + (ci * 80);
      base.y = 80;
      base.updateHitbox();
      cards.set(base, card);
      addChild(base);
      ci++;
    }
    
    addChild(go_btn);
    addChild(cancel_btn);
  }

  public override function update()
  {
    super.update();
    if(Input.mouseReleased) {
      var btn:TextBase;

      btn = cast(scene.collidePoint("cancel_btn", Input.mouseX, Input.mouseY), TextBase);
      if(btn != null) {
        cast(scene, GameController).exitNavigation();
      }

      btn = cast(scene.collidePoint("go_btn", Input.mouseX, Input.mouseY), TextBase);
      if(btn != null) {
        if(tarot_x != null && tarot_y != null) {
          cast(scene, GameController).navigateTo(galaxy.getSector(tarot_x, tarot_y));
        }
      }

      var tarot:Base = cast(scene.collidePoint("tarot_card", Input.mouseX, Input.mouseY), Base); 
      if(tarot != null) {
        var card = cards.get(tarot);
        if(tarot_x == card) {
          tarot_x = null;
        } else if(tarot_y == card) {
          tarot_y = null;
        } else if(tarot_x == null) {
          tarot_x = card;
        } else if(tarot_y == null) {
          tarot_y = card;
        }
        relayout();
      }
    }
  }

  public function relayout()
  {
    var ci = 0;
    for(card in cards.keys()) {
      if(tarot_x == cards.get(card)) {
        card.x = this.x + 30;
        card.y = this.y + 225;
      } else if(tarot_y == cards.get(card)) {
        card.x = this.x + 210;
        card.y = this.y + 225;
      } else {
        card.x = this.x + 40 + (ci * 80);
        card.y = this.y + 80;
      }
      ci++;
    }

    sector_name.text = "Sector Name: ";
    sector_type.text = "Sector Type: ";
    if(tarot_x != null && tarot_y != null) {
      var sector = galaxy.getSector(tarot_x, tarot_y);
      sector_name.text += sector.explored ? sector.title : "???";
      sector_type.text += Std.string(sector.sectorType);
    }
  }

}
