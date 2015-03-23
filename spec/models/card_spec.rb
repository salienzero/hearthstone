require 'spec_helper'

describe Card do
  context "#cast" do
    before(:each) do
      @card = Card.new("cost" => 3, "damage" => 5)
      @player = double(Player, name: "foo")
      @opponent = double(Player, name: "bar")
    end

    it "does nothing and returns false with insufficient mana" do
      turn = double(Turn, mana_pool: 2)
      expect(@card).not_to receive(:run_damage)
      expect(@card.cast(@player, @opponent, turn)).to eq(false)
    end

    context "player has sufficient mana" do
      before(:each) do
        @turn = double(Turn, mana_pool: 4)
      end

      it "returns true" do
        allow(@card).to receive(:run_damage)
        allow(@turn).to receive(:mana_pool=)
        expect(@card.cast(@player, @opponent, @turn)).to eq(true)
      end

      it "reduces the turn's mana pool by the correct amount" do
        allow(@card).to receive(:run_damage)
        expect(@turn).to receive(:mana_pool=).with(1)
        @card.cast(@player, @opponent, @turn)
      end

      it "calls the appropriate routines" do
        allow(@turn).to receive(:mana_pool=)
        expect(@card).to receive(:run_damage)
        @card.cast(@player, @opponent, @turn)
      end
    end
  end

  context "#run_damage" do
    it "reduces opponent HP by the correct amount" do
      card = Card.new("damage" => 5)
      opponent = double(Player, name: "foo", hp: 4)
      expect(opponent).to receive(:hp=).with(-1)
      card.run_damage(opponent)
    end
  end

  context "#run_heal" do
    it "increases player HP by the correct amount" do
      card = Card.new("heal" => 3)
      player = double(Player, name: "foo", hp: 24)
      expect(player).to receive(:hp=).with(27)
      card.run_heal(player)
    end
  end

  context "#run_draw" do
    it "calls #draw on the player with the correct params" do
      card = Card.new("draw" => 4)
      player = double(Player, name: "foo")
      expect(player).to receive(:draw).with(4, false)
      card.run_draw(player)
    end
  end

  context "#run_mana" do
    it "increases mana pool by the correct amount" do
      card = Card.new("mana" => 2)
      turn = double(Turn, mana_pool: 3)
      expect(turn).to receive(:mana_pool=).with(5)
      card.run_mana(turn)
    end
  end

  context "#run_message" do
    it "displays the correct message" do
      card = Card.new("message" => "hello world")
      expect{card.run_message}.to output(card.message + "\n").to_stdout
    end
  end
end
