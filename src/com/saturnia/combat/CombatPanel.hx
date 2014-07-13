package com.saturnia.combat;

import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;
import com.modality.cards.Invoker;
import com.modality.cards.Message;

class CombatPanel extends Base
{
  public var inspector:Inspector;
  public var invoker:Invoker;
  public var cr:CombatReceiver;

  public var deck_text:TextBase;

  public var strategy_pile:CardPileView;
  public var reaction_pile:CardPileView;
  public var discard_pile:CardPileView;

  public var mouseOffsetX:Int;
  public var mouseOffsetY:Int;
  public var heldCard:CardView;
  public var _didCardAction:Bool;

  public var strategyCard:CardView;
  public var reactionCard:CardView;

  public var actionCards:Array<CardView>;

  public function new(_inspector:Inspector, _invoker:Invoker)
  {
    super(0, 0, Assets.getImage("card_spread"));

    inspector = _inspector;
    invoker = _invoker;
 
    cr = new CombatReceiver(inspector.inv);
    invoker.addReceiver(cr);

    _didCardAction = false;

    layer = Constants.OVERLAY_LAYER;

    actionCards = [];

    deck_text = new TextBase(10, 20, 0, 0, "D\nE\nC\nK");
    addChild(deck_text);

    strategy_pile = new CardPileView(530, 20, playStrategy);
    addChild(strategy_pile);

    reaction_pile = new CardPileView(530, 140, playReaction);
    addChild(reaction_pile);

    discard_pile = new CardPileView(700, 140, playDiscard);
    addChild(discard_pile);
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
      var card_pile:CardPileView = cast(scene.collidePoint("cardPile", mouse_x, mouse_y), CardPileView);

      heldCard.moveGraphic(mouse_x-mouseOffsetX, mouse_y-mouseOffsetY);

      strategy_pile.blur();
      reaction_pile.blur();
      discard_pile.blur();

      if(card_pile != null) {
        card_pile.focus();
      }
    } else if(Input.mouseReleased && heldCard != null) {
      var card_pile:CardPileView = cast(scene.collidePoint("cardPile", mouse_x, mouse_y), CardPileView);

      if(card_pile != null) {
        if(card_pile.playCard(heldCard)) {
          heldCard.move(card_pile.x + 5, card_pile.y + 5);
          heldCard.playable = false;
        }
        card_pile.blur();
      }

      var gbg:Base = cast(scene.collidePoint("grid_bg", mouse_x, mouse_y), Base);
      var space:Space = cast(scene.collidePoint("space", mouse_x, mouse_y), Space);
      if(gbg != null) {
        if(space != null) {
          if(playActionTarget(heldCard, space)) {
            heldCard.move(discard_pile.x + 5, discard_pile.y + 5);
            heldCard.playable = false;
          }
        } else {
          if(playAction(heldCard)) {
            heldCard.move(discard_pile.x + 5, discard_pile.y + 5);
            heldCard.playable = false;
          }
        }
      }

      heldCard.putDown();
      heldCard.moveGraphic(0, 0);
      heldCard = null;
      _didCardAction = true;
      inspector.updateGraphic();
    } else {
      var card:CardView = cast(scene.collidePoint("card", mouse_x, mouse_y), CardView);
      if(card != null) {
        inspector.setExplain(card.card.getExplainText());
      }
    }
  }

  public function doingCardAction():Bool
  {
    return _didCardAction || (heldCard != null);
  }

  public function deal()
  {
    inspector.inv.deck.draw(3);

    var count = 0;
    for(card in inspector.inv.deck.hand) {
      card.x = (count * 160) + 50;
      card.y = 10;
      count++;
      addChild(card);
      if(card.card.hasRule("ambient")) playAmbient(card);
    }

    updateDeckText();
  }

  public function updateDeckText()
  {
    deck_text.text = "D\nE\nC\nK\n\n"+inspector.inv.deck.drawPile.length;
  }

  public function playAmbient(cv:CardView):Bool
  {
    if(!cv.card.hasRule("ambient")) return false;  
    invoker.execute(msg("(play ambient)"));
    return invoker.execute(cv.card.getMessage("ambient"));
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

  public function playAction(cv:CardView):Bool
  {
    if(!cv.card.hasRule("action")) return false;
    invoker.execute(msg("(play action)"));
    var response = invoker.execute(cv.card.getMessage("action"));
    return response;
  }

  public function playActionTarget(cv:CardView, space:Space):Bool
  {
    if(!cv.card.hasRule("action")) return false;
    invoker.execute(msg("(play actionTarget)"));
    cr.setTarget(space);
    var response = invoker.execute(cv.card.getMessage("action"));
    cr.clearTarget();
    return response;
  }

  public function msg(str:String):Message
  {
    return Message.read(str);
  }
}
