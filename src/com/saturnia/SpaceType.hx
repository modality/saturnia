package com.saturnia;

import com.saturnia.enums.StarSize;
import com.saturnia.enums.StarColor;
import com.saturnia.enums.PlanetSize;
import com.saturnia.enums.PlanetMatter;
import com.saturnia.enums.DebrisMatter;
import com.saturnia.enums.FactionType;
import com.saturnia.enums.StationShape;

enum SpaceType {
  Voidness;
  Star( size:StarSize, color:StarColor );
  Planet( size:PlanetSize, matter:PlanetMatter );
  Debris( matter:DebrisMatter);
  Hostile;
  Friendly;
  Faction( type:FactionType );
  SpaceStation( shape:StationShape );
}
