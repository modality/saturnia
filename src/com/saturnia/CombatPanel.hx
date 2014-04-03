package com.saturnia;

import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.modality.Base;
import com.modality.TextBase;

class CombatPanel extends Base
{
  public var space:Space;
  public var player:PlayerResources;
  public var deck:Deck;

  public var strategy_pile:CardPile;
  public var action_pile:CardPile;
  public var reaction_pile:CardPile;

  public var heldCard:Card;

  public var strategyCard:Card;
  public var reactionCard:Card;
  public var actionCards:Array<Card>;

  public function new(_space:Space, _player:PlayerResources)
  {
    super(0, 0, Assets.getImage("ui_modal"));

    space = _space;
    player = _player;
    deck = player.deck;

    layer = Constants.OVERLAY_LAYER;
    image.scaleX = 320;
    image.scaleY = 480;

    actionCards = [];

    strategy_pile = new CardPile(10, 200);
    addChild(strategy_pile);

    action_pile = new CardPile(115, 200);
    addChild(action_pile);

    reaction_pile = new CardPile(220, 200);
    addChild(reaction_pile);
    deal();
  }

  public override function update()
  {
  }

  public function deal()
  {
    trace("dealing");
    deck.draw(3);

    var count = 0;
    for(card in deck.hand) {
      card.x = count * 90 + 30;
      card.y = 320;
      card.layer = Constants.OVERLAY_LAYER;
      addChild(card);
    }
  }
  
  public function endTurn()
  {
  }

  public function playStrategy(card:Card)
  {
  }

  public function playAction(card:Card)
  {
  }

  public function playReaction(card:Card)
  {
  }

  public function discard(card:Card)
  {
  }

}
