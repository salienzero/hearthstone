require 'spec_helper'

describe Deck do
  let(:default_decklist) {{"mana_bolt" => 5, "heal" => 3, "cantrip_bolt" => 4}}
  let(:default_deck) {described_class.new(default_decklist)}

  context "#initialize" do
    it "sets up the cards according to the provided decklist" do
      default_decklist.each do |card, count|
        expect(Card).to receive(:new).with(CARDS[card]).exactly(count).times
      end
      expect(default_deck.cards.size).to eq(default_decklist.values.inject(:+))
    end
  end

  context "#shuffle" do
    it "randomizes the order of the cards" do
      expect(default_deck.cards).to receive(:shuffle!)
      default_deck.shuffle
    end
  end

  context "#draw" do
    it "removes the specified number of cards from the deck" do
      draw_count = 4
      expect{default_deck.draw(draw_count)}.to change{default_deck.cards.size}.by(-draw_count)
    end

    it "returns the removed cards as an array" do
      draw_count = 6
      drawn_cards = default_deck.draw(draw_count)
      expect(drawn_cards).to be_instance_of(Array)
      expect(drawn_cards.size).to eq(draw_count)
    end

    it "does not change the deck when called with zero" do
      expect{default_deck.draw(0)}.not_to change{default_deck.cards.size}
    end

    it "returns an empty array when called with zero" do
      expect(default_deck.draw(0)).to eq([])
    end

    it "returns an empty array when deck is empty" do
      empty_deck = described_class.new({})
      expect(empty_deck.draw(0)).to eq([])
    end

    it "removes and returns all cards in deck when draw size > deck size" do
      original_deck_size = default_deck.cards.size
      overdraw_count = original_deck_size + 1
      drawn_cards = default_deck.draw(overdraw_count)
      expect(drawn_cards.size).to eq(original_deck_size)
      expect(default_deck.cards.size).to eq(0)
    end
  end
end
