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
  }
}
