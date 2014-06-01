package com.saturnia;

import yaml.Yaml;
import yaml.Parser;

class CardDatabase
{
  public static var parts:Array<ShipPart>;

  public static function init()
  {
    parts = [];

    var partlist = Yaml.parse(openfl.Assets.getText(Assets.get("cards")), Parser.options().useObjects());
    for(part in cast(partlist, Array<Dynamic>)) {
      parts.push(ShipPart.fromYamlObj(part));
    }
  }

  public static function getPart(name:String):ShipPart
  {
    for(part in parts) {
      if(part.name == name) {
	return part;
      }
    }
    return null;
  }
}
