package com.saturnia;

import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;

class CombatPanel extends Base
{
  public var space:Space;
  public var player:PlayerResources;
  public var tarot:TarotDeck;
  public var hand:Array<TarotCard>;

  public var spread:Base;
  public var act_text:TextBase;
  public var react_text:TextBase;
  public var result_text:TextBase;
  public var go_btn:TextBase;
  public var ok_btn:TextBase;

  public var first_text:TextBase;
  public var second_text:TextBase;
  public var spend_text:TextBase;
  public var third_text:TextBase;
  public var reward_text:TextBase;

  public var act_card:TarotCard;
  public var react_card:TarotCard;
  public var result_card:TarotCard;

  public function new(_space:Space, _player:PlayerResources, _tarot:TarotDeck)
  {
    super();

    space = _space;
    player = _player;
    tarot = _tarot;
    hand = [];

    var modal = Assets.getImage("ui_modal");
    modal.scaleX = 320;
    modal.scaleY = 480;
    this.graphic = modal;
    this.layer = Constants.OVERLAY_LAYER;

    spread = new Base();
    spread.layer = Constants.OVERLAY_LAYER;
    spread.x = 20;
    spread.y = 80;
    spread.graphic = Assets.getImage("ui_spread");

    act_text = new TextBase(0, 0, "ACT");
    act_text.layer = Constants.OVERLAY_LAYER;
    act_text.x = spread.x;
    act_text.y = spread.y - 16;
    act_text.color = 0xFFFFFF;
    act_text.size = Constants.FONT_SIZE_XS;

    react_text = new TextBase(0, 0, "REACT");
    react_text.layer = Constants.OVERLAY_LAYER;
    react_text.x = spread.x + 70;
    react_text.y = spread.y - 16;
    react_text.color = 0xFFFFFF;
    react_text.size = Constants.FONT_SIZE_XS;

    result_text = new TextBase(0, 0, "RESULT");
    result_text.layer = Constants.OVERLAY_LAYER;
    result_text.x = spread.x + 140;
    result_text.y = spread.y - 16;
    result_text.color = 0xFFFFFF;
    result_text.size = Constants.FONT_SIZE_XS;

    go_btn = new TextBase(0, 0, "GO");
    go_btn.layer = Constants.OVERLAY_LAYER;
    go_btn.x = spread.x + 232;
    go_btn.y = spread.y + 51;
    go_btn.color = 0x999999;
    go_btn.size = Constants.FONT_SIZE_MD;
    go_btn.type = "go_btn";
  }

  public override function added()
  {
    scene.add(spread);
    scene.add(act_text);
    scene.add(react_text);
    scene.add(result_text);
    scene.add(go_btn);
    deal();
  }

  public override function removed()
  {
    scene.remove(spread);
    scene.remove(act_text);
    scene.remove(react_text);
    scene.remove(result_text);
    scene.remove(go_btn);
    scene.remove(ok_btn);
    scene.remove(first_text);
    scene.remove(second_text);
    scene.remove(spend_text);
    scene.remove(third_text);
    scene.remove(reward_text);
    scene.remove(act_card);
    scene.remove(react_card);
    scene.remove(result_card);
  }

  public override function update()
  {
    super.update();
    if(Input.mouseReleased) {
      var card:TarotCard = cast(scene.collidePoint("tarot_card", Input.mouseX, Input.mouseY), TarotCard);
      if(card != null) {
        if(!card.selected) {
          card.selected = true;
          if(act_card == null) {
            act_card = card;
            card.x = spread.x;
            card.y = spread.y + 1;
          } else if(react_card == null) {
            react_card = card;
            card.x = spread.x + 70;
            card.y = spread.y + 1;
          } else if(result_card == null) {
            result_card = card;
            card.x = spread.x + 140;
            card.y = spread.y + 1;
          }

          if(act_card != null && react_card != null && result_card != null) {
            go_btn.color = 0xFFFFFF;
          } else {
            go_btn.color = 0x999999;
          }
        } else if(card.selected) {
          card.selected = false;
          if(act_card == card) {
            act_card = null;
          }
          if(react_card == card) {
            react_card = null;
          }
          if(result_card == card) {
            result_card = null;
          }

          card.x = spread.x + (70 * card.position) + 76;
          card.y = spread.y + 181;
        }
        return;
      }

      var btn:TextBase = cast(scene.collidePoint("go_btn", Input.mouseX, Input.mouseY), TextBase);
      if(btn != null) {
        if(act_card != null && react_card != null && result_card != null) {
          play();
        }
        return;
      }

      var btn:TextBase = cast(scene.collidePoint("ok_btn", Input.mouseX, Input.mouseY), TextBase);
      if(btn != null) {
        cast(scene, GameController).exitCombat(space);
      }
    }
  }

  public function deal()
  {
    hand = tarot.draw(3);

    var pos = 0;
    for(card in hand) {
      card.reset();
      card.position = pos;
      card.x = spread.x + (70 * pos) + 76;
      card.y = spread.y + 181;
      card.layer = Constants.OVERLAY_LAYER;
      scene.add(card);
      pos++;
    }
  }
  
  public function play()
  {
    scene.remove(spread);
    scene.remove(act_text);
    scene.remove(react_text);
    scene.remove(result_text);
    scene.remove(go_btn);
    scene.remove(act_card);
    scene.remove(react_card);
    scene.remove(result_card);

    var combat_result = CombatCalculator.play(act_card, react_card, result_card);

    first_text = new TextBase(20, 20, combat_result.actionText());
    second_text = new TextBase(20, 60, combat_result.reactionText());
    spend_text = new TextBase(20, 100, combat_result.penaltyText());
    third_text = new TextBase(20, 140, combat_result.resultText());
    reward_text = new TextBase(20, 180, combat_result.rewardText());

    spend_text.color = combat_result.penaltyColor();
    reward_text.color = combat_result.rewardColor();

    first_text.layer = Constants.OVERLAY_LAYER;
    second_text.layer = Constants.OVERLAY_LAYER;
    third_text.layer = Constants.OVERLAY_LAYER;
    spend_text.layer = Constants.OVERLAY_LAYER;
    reward_text.layer = Constants.OVERLAY_LAYER;

    ok_btn = new TextBase(140, 300, "OK");
    ok_btn.type = "ok_btn";
    ok_btn.size = Constants.FONT_SIZE_MD;
    ok_btn.layer = Constants.OVERLAY_LAYER;

    scene.add(first_text);
    scene.add(second_text);
    scene.add(third_text);
    scene.add(spend_text);
    scene.add(reward_text);
    scene.add(ok_btn);

    player.applyResult(combat_result); 
    player.updateGraphic();
  }

}
