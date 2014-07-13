import com.haxepunk.Engine;
import com.haxepunk.HXP;

import com.saturnia.GameController;
import com.saturnia.Generator;
import com.saturnia.CardDatabase;

class Main extends Engine
{

	override public function init()
	{
	  Assets.init();
	  Generator.init();
	  CardDatabase.init();


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
