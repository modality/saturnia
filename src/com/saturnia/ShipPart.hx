package com.saturnia;

class ShipPart
{
  public var name:String;
  public var cards:Array<Card>;

  public function new()
  {
    cards = [];
  }

  public static function fromYamlObj(obj:Dynamic):ShipPart
  {
    //trace("Building part: "+obj.name);
    var part = new ShipPart();
    part.name = obj.name;
    for(card in cast(obj.cards, Array<Dynamic>)) {
      for(i in 0...Std.parseInt(card.count)) {
        part.cards.push(Card.fromYamlObj(card));
      }
    }

    return part;
  }
}
