class Game
  attr_accessor :players, :turn_number, :starting_mana, :mana_per_turn, :max_mana

  def initialize(players, starting_mana, mana_per_turn, max_mana)
    unless players.size == 2
      raise "Currently Hearthstone only supports exactly 2 players per game, not #{players.size}"
    end

    @players = players
    @starting_mana = starting_mana
    @mana_per_turn = mana_per_turn
    @max_mana = max_mana

    @turn_number = 1
  end

  def run_loop
    puts "Welcome to Hearthstone!"

    @players.shuffle!
    puts "#{players.first.name} has won the die roll and will go first!"

    player_counter = 0

    while !game_over?
      current_turn = Turn.new(self, players[player_counter], players[1 - player_counter])
      current_turn.run_loop
      if player_counter == 0
        player_counter = 1
      else
        player_counter = 0
        @turn_number = @turn_number + 1
      end
    end

    puts "Game has ended!"
    if players.first.alive? && !players.last.alive?
      puts "#{players.first.name} is victorious!"
    elsif !players.first.alive? && players.last.alive?
      puts "#{players.last.name} is victorious!"
    else
      puts "The game is a draw!"
    end
  end

  def game_over?
    players.any? { |player| !player.alive? }
  end
end