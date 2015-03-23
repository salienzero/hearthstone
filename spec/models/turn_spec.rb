require 'spec_helper'

describe Turn do
  let(:game) {double(Game, starting_mana: 1, turn_number: 3, mana_per_turn: 1, max_mana: 10)}
  let(:player) {double(Player, name: "player 1", hp: 25, hand: [])}
  let(:opponent) {double(Player, name: "player 2", hp: 20, hand: [])}

  context "#initialize" do
    it "has the current player draw a card" do
      expect(player).to receive(:draw)
      turn = described_class.new(game, player, opponent)
    end

    it "sets starting mana pool" do
      allow(player).to receive(:draw)
      turn = described_class.new(game, player, opponent)
      expect(turn.mana_pool).to eq([game.starting_mana + (game.turn_number - 1) * game.mana_per_turn, game.max_mana].min)
    end
  end

  context "turn 3" do
    let(:turn) {described_class.new(game, player, opponent)}

    before(:each) do
      allow(player).to receive(:draw)
      allow(game).to receive(:game_over?).and_return(false)
    end

    context "#run_loop" do
      it "ends when user input is empty line" do
        allow(turn).to receive(:gets).and_return("\n")
        turn.run_loop
      end

      it "outputs a warning when user entry is out of range of their hand size" do
        @action_counter = 0
        allow(turn).to receive(:gets) do
          @action_counter += 1
          if @action_counter < 2
            "3\n"
          else
            "\n"
          end
        end

        expect{turn.run_loop}.to output{/described_class::INPUT_OUT_OF_RANGE_MESSAGE/}.to_stdout
      end

      context "casting cards" do
        it "does nothing if casting the card fails" do
          card = double(Card)
          expect(card).to receive(:cast).and_return(false)
          player.hand << card

          @action_counter = 0
          allow(turn).to receive(:gets) do
            @action_counter += 1
            if @action_counter < 2
              "1\n"
            else
              "\n"
            end
          end

          expect{turn.run_loop}.not_to change{player.hand}
        end

        it "removes card from player's hand if casting the card succeeds" do
          card1 = double(Card)
          card2 = double(Card)
          card3 = double(Card)
          card4 = double(Card)
          expect(card3).to receive(:cast).and_return(true)
          allow(player).to receive(:hand).and_return([card1, card2, card3, card4])

          @action_counter = 0
          allow(turn).to receive(:gets) do
            @action_counter += 1
            if @action_counter < 2
              "3\n"
            else
              "\n"
            end
          end

          expect{turn.run_loop}.to change{player.hand}.to([card1, card2, card4])
        end
      end
    end
  end
end
