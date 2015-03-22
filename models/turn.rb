class Turn
  attr_accessor :game, :player, :opponent, :mana_pool

  def initialize(game, player, opponent)
    @game = game
    @player = player
    @opponent = opponent

    @mana_pool = [game.starting_mana + (@game.turn_number - 1) * game.mana_per_turn, game.max_mana].min
    @player.draw
  end

  def run_loop
    turn_ended = false
    while !@game.game_over? && !turn_ended
      display_game_status
      player_action = gets.chomp.to_i
      if player_action.zero?
        turn_ended = true
      elsif player_action > @player.hand.size
        puts "Please enter the number of a card in your hand, or no number to end your turn"
      else
        if @player.hand[player_action - 1].cast(@player, @opponent, self)
          @player.hand.delete_at(player_action - 1)
        end
      end
    end
  end

  def display_game_status
    puts "-"*20
    puts "It is your turn #{@game.turn_number}, #{@player.name}"
    puts "Your HP: #{@player.hp}"
    puts "#{@opponent.name}'s HP: #{@opponent.hp}"
    puts "Available mana: #{@mana_pool}"
    puts "Cards in hand (enter the number to cast):"
    @player.hand.each_with_index do |card, index|
      puts "#{index + 1}: #{card}"
    end
    puts "Hit enter with no number to end your turn"
  end
end
