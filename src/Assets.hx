import com.haxepunk.graphics.Image;

class Assets
{
  public static var assetDictionary:Map<String, String>;

  public static function init()
  {
    assetDictionary = new Map<String, String>();

    assetDictionary.set("icon_cargo", "graphics/icons/cargo.png");
    assetDictionary.set("icon_fuel", "graphics/icons/fuel.png");
    assetDictionary.set("icon_science", "graphics/icons/science.png");
    assetDictionary.set("icon_shields", "graphics/icons/shields.png");

    assetDictionary.set("space_star_blue", "graphics/spaces/star_blue.png");
    assetDictionary.set("space_star_yellow", "graphics/spaces/star_yellow.png");
    assetDictionary.set("space_star_red", "graphics/spaces/star_red.png");
    assetDictionary.set("space_star_exit", "graphics/spaces/star_exit.png");
    assetDictionary.set("space_planet_sprite", "graphics/spaces/planet_sprite.png");
    assetDictionary.set("space_debris_sprite", "graphics/spaces/debris_sprite.png");
    assetDictionary.set("space_planet", "graphics/spaces/planet.png");
    assetDictionary.set("space_raider", "graphics/spaces/raider.png");
    assetDictionary.set("space_hostile", "graphics/spaces/hostile.png");
    assetDictionary.set("space_friendly", "graphics/spaces/friendly.png");
    assetDictionary.set("space_merchant", "graphics/spaces/merchant.png");
    assetDictionary.set("space_star", "graphics/spaces/star.png");
    assetDictionary.set("space_unexplored", "graphics/spaces/unexplored_2.png");
    assetDictionary.set("space_locked", "graphics/spaces/locked_2.png");

    assetDictionary.set("ui_modal", "graphics/ui/modal.png");

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
}

