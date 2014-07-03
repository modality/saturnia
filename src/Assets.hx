import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.TiledImage;
import com.haxepunk.graphics.Text;

class Assets
{
  public static var assetDictionary:Map<String, String>;

  public static function init()
  {
    assetDictionary = new Map<String, String>();

    assetDictionary.set("tarot_0", "graphics/tarot/0_fool.png");
    assetDictionary.set("tarot_1", "graphics/tarot/1_magician.png");
    assetDictionary.set("tarot_2", "graphics/tarot/2_priestess.png");
    assetDictionary.set("tarot_3", "graphics/tarot/3_empress.png");
    assetDictionary.set("tarot_4", "graphics/tarot/4_emperor.png");
    assetDictionary.set("tarot_5", "graphics/tarot/5_hierophant.png");

    assetDictionary.set("icon_cargo", "graphics/icons/cargo.png");
    assetDictionary.set("icon_fuel", "graphics/icons/fuel.png");
    assetDictionary.set("icon_science", "graphics/icons/science.png");
    assetDictionary.set("icon_shields", "graphics/icons/shields.png");

    assetDictionary.set("space_planet", "graphics/spaces/planet.png");
    assetDictionary.set("space_raider", "graphics/spaces/raider.png");
    assetDictionary.set("space_merchant", "graphics/spaces/merchant.png");
    assetDictionary.set("space_star", "graphics/spaces/star.png");
    assetDictionary.set("space_unexplored", "graphics/spaces/unexplored.png");
    assetDictionary.set("space_locked", "graphics/spaces/locked.png");
    assetDictionary.set("space_void", "graphics/spaces/void.png");
    assetDictionary.set("space_station", "graphics/spaces/space_station_sphere.png");

    assetDictionary.set("space_debris_gas", "graphics/spaces/debris_gas.png");
    assetDictionary.set("space_debris_rock", "graphics/spaces/debris_rock.png");
    assetDictionary.set("space_debris_ice", "graphics/spaces/debris_ice_2.png");

    assetDictionary.set("space_tex", "graphics/spaces/spaces.png");
    assetDictionary.set("tile_tex", "graphics/spaces/empty_spaces.png");

    assetDictionary.set("ui_modal", "graphics/ui/modal.png");
    assetDictionary.set("ui_spread", "graphics/ui/tarot_spread.png");
    assetDictionary.set("ui_arrow", "graphics/ui/tarot_pointer.png");

    assetDictionary.set("ui_pile", "graphics/ui/card_pile.png");
    assetDictionary.set("ui_card", "graphics/ui/test_card.png");

    assetDictionary.set("card_action", "graphics/ui/card_action.png");
    assetDictionary.set("card_reaction", "graphics/ui/card_reaction.png");
    assetDictionary.set("card_strategy", "graphics/ui/card_strategy.png");

    assetDictionary.set("card_action_strategy", "graphics/ui/card_action_strategy.png");
    assetDictionary.set("card_action_reaction", "graphics/ui/card_action_reaction.png");
    assetDictionary.set("card_reaction_strategy", "graphics/ui/card_reaction_strategy.png");

    assetDictionary.set("card_back", "graphics/ui/card_back.png");

    assetDictionary.set("cards", "data/cards.yml");
    assetDictionary.set("font", "font/magic_forest.ttf");
  }

  public static function get(asset:String):String
  {
    return assetDictionary.get(asset);
  }

  public static function getImage(asset:String):Image
  {
    return new Image(get(asset));
  }

  public static function getSprite(asset:String, x:Int, y:Int, w:Int, h:Int):TiledImage
  {
    var ti = new TiledImage(get(asset), w, h);
    ti.setOffset(x, y);
    return ti;
  }
}

