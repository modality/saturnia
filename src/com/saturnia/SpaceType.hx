package com.saturnia;

enum SpaceType {
  Start;
  Exit;
  Star;
  Planet(type:String); // "dead", "live", "moon"
  Friendly(type:String); // "engineer", "hacker", "merchant", "military"
  Hostile;
  Debris(type:String); // "rock", "ice"
  Quest;
  Anomaly;
  Voidness;
}
