class Deck
  attr_accessor :cards

  def initialize(decklist)
    @cards = []

    decklist.each do |card, count|
      count.times do
        @cards << Card.new(CARDS[card])
      end
    end
  end

  def shuffle
    @cards.shuffle!
  end

  def draw(count=1)
    @cards.pop(count)
  end
end
