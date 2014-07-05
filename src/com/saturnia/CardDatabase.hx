package com.saturnia;

import yaml.Yaml;
import yaml.Parser;

import com.saturnia.data.ShipPartData;

class CardDatabase
{
  public static var parts:Array<ShipPartData>;

  public static function init()
  {
    parts = [];

    var partlist = Yaml.parse(openfl.Assets.getText(Assets.get("cards")), Parser.options().useObjects());
    for(part in cast(partlist, Array<Dynamic>)) {
      parts.push(ShipPartData.fromYamlObj(part));
    }
  }

  public static function getPartData(name:String):ShipPartData
  {
    for(part in parts) {
      if(part.name == name) {
        return part;
      }
    }
    return null;
  }
}
