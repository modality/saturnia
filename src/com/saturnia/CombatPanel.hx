package com.saturnia;

import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;
import com.modality.cards.Invoker;
import com.modality.cards.Message;

class CombatPanel extends Base
{
  public var player:PlayerResources;
  public var deck:Deck;
  public var invoker:Invoker;
  public var cgr:CardGameReceiver;

  public var draw_pile:CardPile;
  public var strategy_pile:CardPile;
  public var reaction_pile:CardPile;
  public var discard_pile:CardPile;

  public var mouseOffsetX:Int;
  public var mouseOffsetY:Int;
  public var heldCard:CardView;
  public var _didCardAction:Bool;

  public var strategyCard:CardView;
  public var reactionCard:CardView;

  public var actionCards:Array<CardView>;

  public function new(_player:PlayerResources, _invoker:Invoker, _cgr:CardGameReceiver)
  {
    super(0, 0);

    cgr = _cgr;
    invoker = _invoker;

    player = _player;
    deck = player.inv.deck;
    _didCardAction = false;

    layer = Constants.OVERLAY_LAYER;

    actionCards = [];

    draw_pile = new CardPile(0, 0);
    addChild(draw_pile);
    addChild(new TextBase(0, -20, 0, 0, "Draw Deck"));

    strategy_pile = new CardPile(400, 0, playStrategy);
    addChild(strategy_pile);
    addChild(new TextBase(400, -20, 0, 0, "Strategy"));

    reaction_pile = new CardPile(500, 0, playReaction);
    addChild(reaction_pile);
    addChild(new TextBase(500, -20, 0, 0, "Reaction"));

    discard_pile = new CardPile(600, 0, playDiscard);
    addChild(discard_pile);
    addChild(new TextBase(600, -20, 0, 0, "Discard"));
    deal();
  }

  public override function update()
  {
    var mouse_x = Input.mouseX;
    var mouse_y = Input.mouseY;

    _didCardAction = false;

    if(Input.mousePressed && heldCard == null) {
      var card:CardView = cast(scene.collidePoint("card", mouse_x, mouse_y), CardView);
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
      if(space != null) {
        if(playAction(heldCard, space)) {
          heldCard.move(discard_pile.x + 5, discard_pile.y + 5);
          heldCard.playable = false;
        }
      }

      heldCard.putDown();
      heldCard.moveGraphic(0, 0);
      heldCard = null;
      _didCardAction = true;
      player.updateGraphic();
    } else {
      var card:CardView = cast(scene.collidePoint("card", mouse_x, mouse_y), CardView);
      if(card != null) {
        player.setExplain(card.card.getExplainText());
      }
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

  public function playStrategy(cv:CardView):Bool
  {
    if(!cv.card.hasRule("strategy")) return false;
    invoker.execute(msg("(play strategy)"));
    return invoker.execute(cv.card.getMessage("strategy"));
  }

  public function playReaction(cv:CardView):Bool
  {
    if(!cv.card.hasRule("reaction")) return false;
    invoker.execute(msg("(play reaction)"));
    return invoker.execute(cv.card.getMessage("reaction"));
  }

  public function playDiscard(cv:CardView):Bool
  {
    return invoker.execute(msg("(play discard)"));
  }

  public function playAction(cv:CardView, space:Space):Bool
  {
    if(!cv.card.hasRule("action")) return false;
    invoker.execute(msg("(play action)"));
    cgr.setTarget(space);
    var response = invoker.execute(cv.card.getMessage("action"));
    cgr.clearTarget();
    return response;
  }

  public function msg(str:String):Message
  {
    return Message.read(str);
  }
}
