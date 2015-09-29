import haxe.unit.TestRunner;
import flash.system.System;
import test.PlayerResourcesTest;

// lime test flash -Druntest

class TestSuite {
  public static function main()
  {
    var runner = new TestRunner();
    runner.add(new PlayerResourcesTest());
    var success = runner.run();

    trace("success: "+success);

    #if sys
    Sys.exit(success ? 0 : 1);
    #end
  }
}
