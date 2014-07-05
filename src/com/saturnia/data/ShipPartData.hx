package com.saturnia.data;

class ShipPartData
{
  public var name:String;
  public var cards:Array<CardData>;

  public function new()
  {
    cards = [];
  }

  public static function fromYamlObj(obj:Dynamic):ShipPartData
  {
    //trace("Building part: "+obj.name);
    var part = new ShipPartData();
    part.name = obj.name;
    for(card in cast(obj.cards, Array<Dynamic>)) {
      for(i in 0...Std.parseInt(card.count)) {
        part.cards.push(CardData.fromYamlObj(card));
      }
    }

    return part;
  }
}
