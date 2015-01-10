class Enemy
  ATTACK = {
    basic: 5,
    energy:	10,
    physical: 10,
    charge: 20,
    ordnance: 20
  }

  ATTACK_BUFF = {
    stacking: 0.2,
    multi: 0.2,
	  double_attack: 0.5,
	  critical: 0.1,
	  hitrate100: 0.2
  }

  ATTACK_DEBUFF = {
    weak: 0.1,
    miss_chance: 0.2
  }

  DEFENSE = {
    nothing: 0,
    evade: 5,
    first_strike: 5,
    energy_shield: 10,
    mag_shield: 10,
    damage_reduction: 15,
    tank: 15,
    thorny: 15
  }

	DEFENSE_BUFF = {
	  high_hp: 0.3,
	  resist_physical: 0.3,
	  resist_energy: 0.3
	}

	DEFENSE_DEBUFF = {
    low_hp: 0.3,
    weak_physical: 0.3,
    weak_energy: 0.4
	}

	def get_enemy_set(target)
    enemies = []
    1000.times do
      enemies << get_enemy(target)
    end

    enemies.select do |enemy|
      enemy[:score] > (target * 0.8) && enemy[:score] < (target * 1.25)
    end
	end

	def get_enemy(target)
    powers = []

    attack = ATTACK.keys.sample
    defense = DEFENSE.keys.sample

    powers << attack << defense

    score = ATTACK[attack] + DEFENSE[defense]
    if score > target
      if rand < 0.5 
        debuff = ATTACK_DEBUFF.keys.sample
        score *= 1 - ATTACK_DEBUFF[debuff]
      else
        debuff = DEFENSE_DEBUFF.keys.sample
        score *= 1 - DEFENSE_DEBUFF[debuff]
      end
      powers << debuff
    elsif score < target
      if rand < 0.5 
        buff = ATTACK_BUFF.keys.sample
        score *= 1 + ATTACK_BUFF[buff]
      else
        buff = DEFENSE_BUFF.keys.sample
        score *= 1 + DEFENSE_BUFF[buff]
      end
      powers << buff
    end

    { powers: powers, score: score }
  end
end
