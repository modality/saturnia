package com.saturnia;

import com.modality.AugRandom;

class Deck
{
  public var cards:Array<CardView>;

  public var drawPile:Array<CardView>;
  public var hand:Array<CardView>;
  public var discardPile:Array<CardView>;

  public function new()
  {
    cards = [];
    var part = CardDatabase.getPart("Crew");
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
