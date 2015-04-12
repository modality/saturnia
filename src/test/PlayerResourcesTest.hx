package test;

import haxe.unit.TestCase;
import com.saturnia.PlayerResources;

class PlayerResourcesTest extends TestCase
{
  public var player:PlayerResources;

  public override function setup():Void
  {
    player = Fixtures.playerResources();
  }

  public function testSpendCargo():Void
  {
    var initialAmount = player.totalCargo();
    var spendAmount = Std.random(player.totalCargo()) + 1;

    player.spendCargo(spendAmount);

    assertEquals(initialAmount - spendAmount, player.totalCargo());
  }
}
