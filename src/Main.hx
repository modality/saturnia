import com.haxepunk.Engine;
import com.haxepunk.HXP;

import com.saturnia.GameController;
import com.saturnia.Generator;
import com.saturnia.MerchantGoods;

class Main extends Engine
{

  override public function init()
  {
    Data.load(openfl.Assets.getText("data/items.cdb"));
    Assets.init();
    Generator.init();
    MerchantGoods.init();

#if debug
    HXP.console.enable();
#end
    HXP.scene = new GameController();
  }

  public static function main()
  {
    new Main();
  }
}
