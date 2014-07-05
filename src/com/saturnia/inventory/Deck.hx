package com.saturnia.inventory;

import com.modality.AugRandom;
import com.saturnia.combat.CardView;

class Deck
{
  public var cards:Array<CardView>;
  public var drawPile:Array<CardView>;
  public var hand:Array<CardView>;
  public var discardPile:Array<CardView>;

  public function new()
  {
    cards = [];
    var part = CardDatabase.getPartData("Crew");
    for(card in part.cards) {
      var cv = new CardView(card);
      cards.push(cv);
    }

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
