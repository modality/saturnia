import haxe.Timer;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;

class SoundManager
{
  public static var soundDictionary:Map<String, Sfx>;

  public static function init()
  {
    HXP.volume = 0.5;
    soundDictionary = new Map<String, Sfx>();

    var pathTo = function(filename:String):String {
#if flash
		  return "audio/" + filename + ".mp3";
#else
      return "audio/" + filename + ".wav";
#end
    };

    soundDictionary.set("bomb", new Sfx(pathTo("bomb")));
    soundDictionary.set("destroy", new Sfx(pathTo("destroy")));
    soundDictionary.set("compound_attack", new Sfx(pathTo("compound_attack")));
    soundDictionary.set("hit0", new Sfx(pathTo("hit1")));
    soundDictionary.set("hit1", new Sfx(pathTo("hit2")));
    soundDictionary.set("laser_shoot", new Sfx(pathTo("laser_shoot")));
    soundDictionary.set("light_attack", new Sfx(pathTo("light_attack")));
    soundDictionary.set("miss", new Sfx(pathTo("miss")));
    soundDictionary.set("space_teleport", new Sfx(pathTo("space_teleport")));
    soundDictionary.set("whoosh", new Sfx(pathTo("whoosh")));
  }

  public static function play(name:String)
  {
    soundDictionary.get(name).play();
  }

  public static function playIn(name:String, ms:Int)
  {
    Timer.delay(function() {
      play(name);
    }, ms);
  }
}
