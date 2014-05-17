package com.saturnia;

import com.modality.AugRandom;

class Deck
{
  public var cards:Array<Card>;

  public var drawPile:Array<Card>;
  public var hand:Array<Card>;
  public var discardPile:Array<Card>;

  public function new()
  {
    cards = [];

    var c:Card;

    c = new Card();
    c.card_name = "Pepper\nRay";
    c.has_action = true;
    c.action_effect = "effect(opponent, shields, loss, 1)";
    c.updateGraphic();

    cards.push(c);

    c = new Card();
    c.card_name = "Pepper\nRay";
    c.has_action = true;
    c.action_effect = "effect(opponent, shields, loss, 1)";
    c.updateGraphic();

    cards.push(c);

    c = new Card();
    c.card_name = "Shield\nResonance";
    c.has_strategy = true;
    c.strategy_trigger = "play(self, discard)";
    c.strategy_effect = "effect(self, shields, gain, 1)";
    c.reaction_trigger = "effect(self, shields, lose, *)";
    c.reaction_effect = "effect(self, shields, gain, 1)";
    c.updateGraphic();

    cards.push(c);

    reset();
  }
  
  public function reset():Void
  {
    drawPile = AugRandom.shuffle(cards);
    hand = [];
    discardPile = [];
  }

  public function draw(amount:Int):Void
  {
    hand = hand.concat(drawPile.splice(0, amount));
    for(card in hand) {
      card.playable = true;
    }
  }
}
