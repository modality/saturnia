package com.saturnia;

import com.modality.AugRandom;
import com.modality.cards.Message;

class CrewMemberManager
{
  public static var crewMembers:Array<String>;

  public static function getCrew(id:String):CrewMember
  {
    var crewMemberData:Data.CrewMembers = Data.crewMembers.resolve(id);
    var crewMember = new CrewMember();

    crewMember.name = crewMemberData.name;
    crewMember.description = crewMemberData.description;
    crewMember.effectName = crewMemberData.effectName;
    crewMember.effects = Message.read(crewMemberData.effects);

    return crewMember;
  }

  public static function getRandomCrew():CrewMember
  {
    if(crewMembers == null) {
      crewMembers = [for(p in Data.crewMembers.all) p.id.toString()];
    }

    return getCrew(crewMembers[Std.random(crewMembers.length)]);
  }
}
