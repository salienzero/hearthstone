class Card
  attr_accessor :name, :cost, :damage, :heal, :draw, :mana, :message

  def initialize(card_definition)
    @name = card_definition["name"]
    @cost = card_definition["cost"].to_i
    @damage = card_definition["damage"].to_i
    @heal = card_definition["heal"].to_i
    @draw = card_definition["draw"].to_i
    @mana = card_definition["mana"].to_i
    @message = card_definition["message"]
  end

  def to_s
    "#{@name} (cost: #{@cost})"
  end

  def cast(player, opponent, turn)
    puts "*"*20
    if @cost > turn.mana_pool
      puts "You don't have enough mana to cast #{@name}, it costs #{@cost}!"
      return false
    else
      puts "Casting #{@name}:"
      turn.mana_pool = turn.mana_pool - @cost
      run_damage(opponent) if @damage > 0
      run_heal(player) if @heal > 0
      run_draw(player) if @draw > 0
      run_mana(turn) if @mana > 0
      run_message unless @message.nil?
      return true
    end
  end

  def run_damage(opponent)
    opponent.hp = opponent.hp - @damage
    puts "#{opponent.name} loses #{@damage} HP, now at #{opponent.hp} HP"
  end

  def run_heal(player)
    player.hp = player.hp + @heal
    puts "You gain #{@heal} HP, now at #{player.hp} HP"
  end

  def run_draw(player)
    player.draw(@draw, false)
    puts "You draw #{@draw} card#{@draw > 1 ? "s": ""}"
  end

  def run_mana(turn)
    turn.mana_pool = turn.mana_pool + @mana
    puts "You gain #{mana} mana, now at #{turn.mana_pool} mana"
  end

  def run_message
    puts @message
  end
end
