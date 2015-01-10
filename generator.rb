class Generator
  WEIGHTS = {
    :yes   => 1..1,
    :maybe => 0..1,
    :none  => 0..0,
    :low   => 2..4,
    :high  => 4..7,
    :wide  => 2..7
  }

  SYSTEM = {
    stars:    :maybe,
    planets:  :wide,
    friendly: :high,
    hostile:  :low,
    debris:   :low,
    quest:    :maybe,
    anomaly:  :none
  }

  NEBULA = {
    stars:    :wide,
    planets:  :none,
    friendly: :low,
    hostile:  :high,
    debris:   :high,
    quest:    :none,
    anomaly:  :none
  }

  ASTEROID = {
    stars:    :none,
    planets:  :wide,
    friendly: :low,
    hostile:  :high,
    debris:   :high,
    quest:    :none,
    anomaly:  :none
  }

  ANOMALY = {
    stars:    :none,
    planets:  :none,
    friendly: :none,
    hostile:  :high,
    debris:   :none,
    quest:    :none,
    anomaly:  :yes
  }

  SECTORS = [
    SYSTEM, SYSTEM, SYSTEM,
    NEBULA, NEBULA, NEBULA,
    ASTEROID, ASTEROID, ASTEROID,
    ANOMALY
  ]

  def build_sector
    sector = {}
    type = SECTORS.sample
    spaces = ["start", "exit"]

    type.each do |what, weight|
      rand(WEIGHTS[weight]).times do
        next if spaces.length >= 25
        spaces << case what
        when :stars
          "star"
        when :planets
          "planet"
        else
          what.to_s
        end
      end
    end

    while spaces.length < 25 do
      spaces << "void"
    end

    spaces.shuffle!
    sector[:spaces] = spaces
    sector[:title] = case type
    when SYSTEM
      "Star System"
    when NEBULA
       "Nebula"
    when ASTEROID
      "Asteroid Belt"
    when ANOMALY
      "Anomaly"
    end

    #5.times do |i|
    #  5.times do |j|
    #    print sector[(i*5)+j].center(10)
    #  end
    #  print "\n"
    #end
    
    sector
  end

  def build_trader(level)
    
  end

  def find_cards(cards)
    locations = {}

    cards.last(cards.length - 2).each do |card|
      valid = false
      index = cards.index(card)
      tuple = []

      while !valid
        valid = true
        picks = cards.first(index)
        tuple = [picks.sample, picks.sample]

        valid = false if tuple[0] == tuple[1]
        valid = false if tuple.index(cards[index-1]) == nil
      end

      locations[card] = tuple
    end

    locations
  end

  def build_galaxy
    cards = %w(a b c d e)
    goods = %w(v w x y z)

    sectors = []

    cards.each do |card1|
      cards.each do |card2|
        sector = {}
        if card1 == card2
          sector[:location] = "SET PIECE #{card1}"
        elsif
          sector[:location] = "SECTOR #{card1} x #{card2}"
          sg = goods.shuffle

          sector[:buys] = sg.first 3
          sector[:sells] = sg.last 2
          #puts "SELLS: #{sg[0]}, #{sg[1]}"
          #
          data = build_sector
          sector[:title] = data[:title]
          sector[:spaces] = data[:spaces]
        end
        sectors << sector
      end
    end

    bought = []
    sold = []
    types = []

    sectors.each do |sector|
      bought << sector[:buys] if sector[:buys]
      sold << sector[:sells] if sector[:sells]
      types << sector[:title] if sector[:title]
    end

    bought.flatten.uniq!
    sold.flatten.uniq!
    types.flatten.uniq!

    return "not enough bought" if bought.length < 5
    return "not enough sold" if sold.length < 5
    return "not all types" if types.length < 4

    puts sectors
  end

end


class Trader
  attr_accessor :max, :refresh, :sell_rate, :buy_rate, :time, :inventory

  MAX_CARRIED  = 50..100
  REFRESH_RATE = 25..50
  SELL_RATE    = 10..30
  BUY_RATE     = 20..50

  def initialize
    @max = rand(MAX_CARRIED)
    @refresh = rand(REFRESH_RATE)
    @sell_rate = rand(SELL_RATE)
    @buy_rate = rand(BUY_RATE)

    @time = rand(refresh)
    @inventory = calc_inventory
  end

  def logistic(t)
    1 / (1 + Math.exp(-t))
  end

  def logit(y)
    -Math.log((1/y) - 1)
  end

  def calc_inventory
    inventory = (logistic((12 * time / refresh) - 6) * max).ceil
  end

  def calc_time
    time = (logit(inventory/max) * refresh).floor
  end

  def increment_time
    time = 1 + time
    calc_inventory
  end
end
