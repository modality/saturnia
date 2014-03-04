package com.saturnia;

import com.modality.AugRandom;

class TarotDeck
{
  public var cards:Array<TarotCard>;

  public function new()
  {
    cards = [];
    cards.push(new TarotCard("Fool", "none", 0));
    cards.push(new TarotCard("Magician", "none", 1));
    cards.push(new TarotCard("High Priestess", "water", 2));
    cards.push(new TarotCard("Empress", "fire", 3));
    cards.push(new TarotCard("Emperor", "earth", 4));
    cards.push(new TarotCard("Hierophant", "air", 5));
  }

  public function draw(amount:Int):Array<TarotCard>
  {
    var shuffled = AugRandom.shuffle(cards);
    return shuffled.splice(0, amount);
  }
}
