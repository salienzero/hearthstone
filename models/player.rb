class Player
  attr_accessor :name, :deck, :hp, :hand, :hp_loss_on_empty_draw

  def initialize(name, decklist, hp, starting_hand_size, hp_loss_on_empty_draw)
    @name = name
    @deck = Deck.new(decklist)
    @hp = hp
    @hp_loss_on_empty_draw = hp_loss_on_empty_draw

    @deck.shuffle
    @hand = @deck.draw(starting_hand_size)
  end

  def draw(count=1, hp_loss_if_empty=true)
    drawn_cards = @deck.draw(count)
    @hp = @hp - 1 if hp_loss_if_empty && drawn_cards.empty?
    @hand << drawn_cards
    @hand.flatten!
  end

  def alive?
    @hp > 0
  end
end
