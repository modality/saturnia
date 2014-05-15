package com.saturnia;

import yaml.Yaml;

class GameData
{
  public static function init()
  {
    var yams = Yaml.read(Assets.get("equipment"));
    
  }
}
