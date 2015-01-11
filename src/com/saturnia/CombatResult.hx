package com.saturnia;

class CombatResult
{
  public var hit:Bool = false;
  public var critical:Bool = false;
  public var forcedHit:Bool = false;
  public var damage:Int = 0;
  public var attackType:AttackType = AttackType.Basic;
}
