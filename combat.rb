module Enumerable
  def sum
    self.inject(0){|accum, i| accum + i }
  end

  def mean
    self.sum/self.length.to_f
  end

  def sample_variance
    m = self.mean
    sum = self.inject(0){|accum, i| accum +(i-m)**2 }
    sum/(self.length - 1).to_f
  end

  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end
end 

class Combat
  attr_accessor :arcana, :ship, :loud

  # {:shields=>566, :fuel=>-61, :science=>26, :cargo=>-48}

  def initialize(loud = false)
    @arcana = [
      {name: "Fool", element: "none", number: 0},
      {name: "Magician", element: "none", number: 1},
      {name: "High Priestess", element:  "water", number: 2},
      {name: "Empress", element: "fire", number: 3},
      {name: "Emperor", element: "earth", number: 4},
      {name: "Hierophant", element: "air", number: 5}
    ]

    @ship = {
      shields: 0,
      fuel: 0,
      science: 0,
      cargo: 0
    }

    @loud = loud
  end

  def reset_game
    ship[:shields] = 0
    ship[:fuel] = 0
    ship[:science] = 0
    ship[:cargo] = 0
  end

  def run_test
    results = []

    100.times do
      reset_game
      1000.times do
        cards = arcana.sample(3).map {|c| c[:number] }
        play(*cards)
      end
      results << ship.clone
    end

    fuel = results.map {|r| r[:fuel] }
    puts "fuel mean: #{fuel.mean}  std dev: #{fuel.standard_deviation}"

    shields = results.map {|r| r[:shields] }
    puts "shields mean: #{shields.mean}  std dev: #{shields.standard_deviation}"

    science = results.map {|r| r[:science] }
    puts "science mean: #{science.mean}  std dev: #{science.standard_deviation}"

    cargo = results.map {|r| r[:cargo] }
    puts "cargo mean: #{cargo.mean}  std dev: #{cargo.standard_deviation}"

    results
  end

  def deal
    puts "Fuel: #{ship[:fuel]} / Shields: #{ship[:shields]} / Cargo: #{ship[:cargo]} / Science #{ship[:science]}" if loud

    puts "Spread:" if loud
    arcana.sample(3).each do |card|
      puts "#{card[:number]} - #{card[:name]}"
    end

    nil
  end

  def play(action, reaction, result)
    action = arcana[action]
    reaction = arcana[reaction]
    result = arcana[result]

    delta_1 = (action[:number] - reaction[:number]).abs
    delta_2 = (action[:number] - result[:number]).abs
    delta_3 = (reaction[:number] - result[:number]).abs

    element_1 = action[:element]
    element_2 = reaction[:element]
    element_3 = result[:element]

    if element_2 == "none"
      if element_3 == "none"
        element_3 = ["air", "water", "fire", "earth"].sample
      end
      element_2 = (["air", "water", "fire", "earth"] - [element_3]).sample
    elsif element_3 == "none"
      element_3 = (["air", "water", "fire", "earth"] - [element_2]).sample
    end

    deltas = [delta_1, delta_2, delta_3].sort

    case element_1
    when "air"
      puts "You maneuver deftly." if loud
      delta_1 = deltas.sum
      delta_2 = (1...delta_1).to_a.sample
      delta_1 = delta_1 - delta_2
    when "water"
      puts "You try to evade enemy attacks." if loud
      delta_1 = deltas[0]
      delta_2 = deltas[1]
    when "fire"
      puts "You attack fiercely." if loud
      delta_1 = deltas[1]
      delta_2 = deltas[2]
    when "earth"
      puts "You try to disable the enemy." if loud
      delta_1 = (deltas[0] + deltas[2]) / 2
      delta_2 = delta_1
    when "none"
      puts "You wait for the enemy to move first." if loud
      case [1, 2, 3].sample
      when 1
        delta_1 = deltas.sum
        delta_2 = 0
      when 2
        delta_1 = 0
        delta_2 = deltas.sum
      when 3
        delta_1 = deltas.sample * 2
        delta_2 = deltas.sample * 2
      end
    end

    case element_2
    when "air"
      puts "The enemy attack fries your circuits. -#{delta_1} science" if loud
      ship[:science] -= delta_1
    when "water"
      puts "Your shields absorb the attack. -#{delta_1} shields" if loud
      ship[:shields] -= delta_1
    when "fire"
      puts "You consume extra fuel. -#{delta_1} fuel" if loud
      ship[:fuel] -= delta_1
    when "earth"
      puts "The enemy attack damages your cargo. -#{delta_1} cargo" if loud
      ship[:cargo] -= delta_1
    when "none"
      puts "The enemy is destroyed!" if loud
    end
    
=begin
    if ship[:shields] < 0
      puts "You have been destroyed!"
      return
    end

    if ship[:fuel] < 0
      puts "You are out of fuel!"
      return
    end

    if ship[:science] < 0
      ship[:science] = 0
    end

    if ship[:cargo] < 0
      ship[:cargo] = 0
    end

    if delta_2 == 0
      return
    end
=end

    if element_3 == "none"
      element_3 = ["air", "water", "fire", "earth"].sample
    end

    case element_3
    when "air"
      puts "You download data from the enemy. +#{delta_2} science" if loud
      ship[:science] += delta_2
    when "water"
      puts "Your shields are recharged through EM resonance. +#{delta_2} shields" if loud
      ship[:shields] += delta_2
    when "fire"
      puts "You find fuel in the enemy wreckage. +#{delta_2} fuel" if loud
      ship[:fuel] += delta_2
    when "earth"
      puts "You find cargo in the enemy wreckage. +#{delta_2} cargo" if loud
      ship[:cargo] += delta_2
    when "none"
      puts "You don't find anything." if loud
    end

    nil
  end
end
