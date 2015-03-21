class Player
  attr_accessor :deck, :hp, :hand

  def initialize(decklist, hp, starting_hand_size)
    @deck = Deck.new(decklist)
    @hp = hp
    @deck.shuffle
    @hand = @deck.draw(starting_hand_size)
  end
end