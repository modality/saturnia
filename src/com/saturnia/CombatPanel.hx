package com.saturnia;

import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;

class CombatPanel extends Base
{
  public var player:PlayerResources;
  public var deck:Deck;

  public var draw_pile:CardPile;
  public var strategy_pile:CardPile;
  public var reaction_pile:CardPile;
  public var discard_pile:CardPile;

  public var mouseOffsetX:Int;
  public var mouseOffsetY:Int;
  public var heldCard:Card;
  public var _didCardAction:Bool;

  public var strategyCard:Card;
  public var strategyTrigger:CombatTrigger;

  public var reactionCard:Card;
  public var reactionTrigger:CombatTrigger;

  public var actionCards:Array<Card>;

  public function new(_player:PlayerResources)
  {
    super(0, 0);

    player = _player;
    deck = player.inv.deck;
    _didCardAction = false;

    layer = Constants.OVERLAY_LAYER;

    actionCards = [];

    draw_pile = new CardPile(0, 0);
    addChild(draw_pile);
    addChild(new TextBase(0, -20, "Draw Deck"));

    strategy_pile = new CardPile(400, 0, playStrategy);
    addChild(strategy_pile);
    addChild(new TextBase(400, -20, "Strategy"));

    reaction_pile = new CardPile(500, 0, playReaction);
    addChild(reaction_pile);
    addChild(new TextBase(500, -20, "Reaction"));

    discard_pile = new CardPile(600, 0, discardCard);
    addChild(discard_pile);
    addChild(new TextBase(600, -20, "Discard"));
    deal();
  }

  public override function update()
  {
    var mouse_x = Input.mouseX;
    var mouse_y = Input.mouseY;
    _didCardAction = false;

    if(Input.mousePressed && heldCard == null) {
      var card:Card = cast(scene.collidePoint("card", mouse_x, mouse_y), Card);
      if(card != null && card.playable) {
        heldCard = card;
        heldCard.pickUp();
        mouseOffsetX = mouse_x;
        mouseOffsetY = mouse_y;
      }
    } else if(Input.mouseDown && heldCard != null) {
      var card_pile:CardPile = cast(scene.collidePoint("cardPile", mouse_x, mouse_y), CardPile);

      heldCard.moveGraphic(mouse_x-mouseOffsetX, mouse_y-mouseOffsetY);

      draw_pile.blur();
      strategy_pile.blur();
      reaction_pile.blur();
      discard_pile.blur();

      if(card_pile != null) {
        card_pile.focus();
      }
    } else if(Input.mouseReleased && heldCard != null) {
      var card_pile:CardPile = cast(scene.collidePoint("cardPile", mouse_x, mouse_y), CardPile);

      if(card_pile != null) {
        if(card_pile.playCard(heldCard)) {
          heldCard.move(card_pile.x + 5, card_pile.y + 5);
          heldCard.playable = false;
        }
        card_pile.blur();
      }

      var space:Space = cast(scene.collidePoint("space", mouse_x, mouse_y), Space);
      if(space != null && space.encounter != null) {
        if(playAction(heldCard, space.encounter.inventory)) {
          heldCard.move(discard_pile.x + 5, discard_pile.y + 5);
          heldCard.playable = false;
        }
      }

      heldCard.putDown();
      heldCard.moveGraphic(0, 0);
      heldCard = null;
      _didCardAction = true;
      player.updateGraphic();
    }
  }

  public function doingCardAction():Bool
  {
    return _didCardAction || (heldCard != null);
  }

  public function deal()
  {
    deck.draw(3);

    var count = 0;
    for(card in deck.hand) {
      card.x = (count * 90) + 120;
      card.y = 0;
      count++;
      addChild(card);
    }
  }

  public function checkTriggerAction(ct:CombatTrigger, action:String, opponent:Inventory = null):Bool {
    var interrupt = false;
    if(ct != null && ct.actionWillTrigger(action)) {
      if(ct.apply(player.inv, opponent)) {
        if(ct.trigger_interrupt) interrupt = true;
        if(ct.trigger_expire) ct = null;
      } else {
        trace("Could not apply trigger! "+ct.trigger);
      }
    }
    return interrupt;
  }
  
  public function playStrategy(card:Card):Bool
  {
    if(!card.has_strategy) return false;

    if(checkTriggerAction(reactionTrigger, "strategy")) return true;
    if(checkTriggerAction(strategyTrigger, "strategy")) return true;

    strategyCard = card;
    strategyTrigger = new CombatTrigger(card.strategy_trigger, card.strategy_effect);

    return true;
  }

  public function playAction(card:Card, opponent:Inventory):Bool
  {
    if(!card.has_action) return false;

    if(checkTriggerAction(reactionTrigger, "action", opponent)) return true;
    if(checkTriggerAction(strategyTrigger, "action", opponent)) return true;

    var ce = new CombatEffect(card.action_effect);
    return ce.apply(player.inv, opponent);
  }

  public function playReaction(card:Card):Bool
  {
    if(!card.has_reaction) return false;

    if(checkTriggerAction(reactionTrigger, "reaction")) return true;
    if(checkTriggerAction(strategyTrigger, "reaction")) return true;

    reactionCard = card;
    reactionTrigger = new CombatTrigger(card.reaction_trigger, card.reaction_effect);

    return true;
  }

  public function discardCard(card:Card):Bool
  {
    if(checkTriggerAction(reactionTrigger, "discard")) return true;
    if(checkTriggerAction(strategyTrigger, "discard")) return true;

    return true;
  }
}
