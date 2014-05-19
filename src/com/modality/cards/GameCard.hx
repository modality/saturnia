package com.modality.cards;

class GameCard {
  public var zone:Zone;

  public function new(_zone:Zone)
  {
    zone = _zone;
    zone.addCard(this);
  }

  public function moveTo(_zone):Result
  {
    return zone.invoker(execute(Message.newFromString("moveCard from: "+zone.name+" to: "+_zone.name)));
  }
}
