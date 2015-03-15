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
    assetDictionary.set("icon_gear", "graphics/icons/gear.png");
    assetDictionary.set("icon_energy", "graphics/icons/energy.png");
    assetDictionary.set("icon_cycle", "graphics/icons/cycle.png");
    assetDictionary.set("icon_selector", "graphics/icons/selector.png");

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
    assetDictionary.set("space_star", "graphics/spaces/star.png");
    assetDictionary.set("space_explored", "graphics/spaces/unexplored_2.png");
    assetDictionary.set("space_locked", "graphics/spaces/locked_2.png");
    assetDictionary.set("space_explorable", "graphics/spaces/explorable.png");
    assetDictionary.set("space_fog", "graphics/spaces/fogofwar.png");
    assetDictionary.set("space_engineer", "graphics/spaces/engineer.png");
    assetDictionary.set("space_hacker", "graphics/spaces/hacker.png");
    assetDictionary.set("space_military", "graphics/spaces/military.png");
    assetDictionary.set("space_merchant", "graphics/spaces/merchant.png");

    assetDictionary.set("overlay_friendly", "graphics/spaces/friendly_overlay.png");
    assetDictionary.set("overlay_hostile", "graphics/spaces/enemy_overlay.png");
    assetDictionary.set("overlay_space", "graphics/spaces/space_overlay.png");

    assetDictionary.set("marble_logo", "graphics/ui/marble.png");
    assetDictionary.set("ui_modal", "graphics/ui/modal.png");
    assetDictionary.set("ui_coffee", "graphics/ui/hot_coffee.png");
    assetDictionary.set("ui_power_panel", "graphics/ui/power_panel.png");
    assetDictionary.set("sector_anomaly", "graphics/ui/anomaly_spread.png");
    assetDictionary.set("sector_system", "graphics/ui/system_spread.png");
    assetDictionary.set("sector_asteroid", "graphics/ui/asteroid_spread.png");
    assetDictionary.set("sector_nebula", "graphics/ui/nebula_spread.png");

    assetDictionary.set("tarot_0", "graphics/tarot/0_fool.png");
    assetDictionary.set("tarot_1", "graphics/tarot/1_magician.png");
    assetDictionary.set("tarot_2", "graphics/tarot/2_priestess.png");
    assetDictionary.set("tarot_3", "graphics/tarot/3_empress.png");
    assetDictionary.set("tarot_4", "graphics/tarot/4_emperor.png");
    assetDictionary.set("tarot_5", "graphics/tarot/5_hierophant.png");

    assetDictionary.set("font", "font/dos_vga.ttf");
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

