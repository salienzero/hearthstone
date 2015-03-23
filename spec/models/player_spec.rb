require 'spec_helper'

describe Player do
  let(:default_decklist) {{"mana_bolt" => 5, "heal" => 3, "cantrip_bolt" => 4}}

  context "#initialize" do
    it "creates and shuffles a deck" do
      deck = double(Deck)
      allow(Deck).to receive(:new).with(default_decklist).and_return(deck)
      allow(deck).to receive(:draw)
      expect(deck).to receive(:shuffle)
      described_class.new("foo", default_decklist, 30, 4, 1)
    end

    it "sets starting hp" do
      starting_hp = 15
      foo_player = described_class.new("foo", default_decklist, starting_hp, 4, 1)
      expect(foo_player.hp).to eq(starting_hp)
    end

    it "draws a starting hand" do
      starting_hand_size = 6
      deck = double(Deck)
      hand = [1,2,3,4,5,6]
      allow(Deck).to receive(:new).with(default_decklist).and_return(deck)
      expect(deck).to receive(:draw).with(starting_hand_size).and_return(hand)
      allow(deck).to receive(:shuffle)
      foo_player = described_class.new("foo", default_decklist, 30, starting_hand_size, 1)
      expect(foo_player.hand).to eq(hand)
    end
  end

  context "default player" do
    let(:foo_player) {described_class.new("foo", default_decklist, 30, 4, 1)}

    context "#draw" do
      it "draws the specified number of cards from the deck" do
        draw_count = 3
        expect(foo_player.deck).to receive(:draw).with(draw_count).and_call_original
        foo_player.draw(draw_count)
      end

      it "adds drawn cards to hand" do
        starting_hand = [1,2,3]
        drawn_cards = [4,5]
        foo_player.hand = starting_hand
        expect(foo_player.deck).to receive(:draw).and_return(drawn_cards)
        expect{foo_player.draw}.to change{foo_player.hand}.to(starting_hand + drawn_cards)
      end

      context "no cards drawn" do
        before(:each) do
          allow(foo_player.deck).to receive(:draw).and_return([])
        end

        it "reduces player hp appropriately if hp_loss_if_empty is true" do
          expect{foo_player.draw(3, true)}.to change{foo_player.hp}.by(-foo_player.hp_loss_on_empty_draw)
        end

        it "does not change player hp if hp_loss_if_empty is false" do
          expect{foo_player.draw(3, false)}.not_to change{foo_player.hp}
        end

        it "does not change player hand" do
          expect{foo_player.draw(3)}.not_to change{foo_player.hand}
        end
      end
    end

    context "#alive?" do
      it "returns true when hp > 0" do
        expect(foo_player.alive?).to be_truthy
      end

      it "returns false when hp = 0" do
        foo_player.hp = 0
        expect(foo_player.alive?).to be_falsey
      end

      it "returns false when hp < 0" do
        foo_player.hp = -5
        expect(foo_player.alive?).to be_falsey
      end
    end
  end
end
