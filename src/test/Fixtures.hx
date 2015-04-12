package test;

import com.saturnia.Generator;
import com.saturnia.PlayerResources;

class Fixtures
{
  public static function playerResources():PlayerResources
  {
    Generator.init();
    var player = new PlayerResources();

    for(i in 0...Constants.NUM_TRADE_GOODS) {
      player.cargos.set(Generator.generateTradeGood(), Std.random(100));
    }

    return player;
  }
}
