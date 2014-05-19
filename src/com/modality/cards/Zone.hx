package com.modality.cards;

class Zone {
  public var name:String;
  public var cards:Array<GameCard>;
  public var invoker:Invoker;

  public function new(_name:String, _invoker:Invoker)
  {
    name = _name;
  }
  public function addCard(card:GameCard):Void
  {
    cards.remove(card);
    cards.push(card);
  }

  public function removeCard(card:GameCard):Void
  {
    cards.remove(card);
  }
}
