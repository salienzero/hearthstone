require 'spec_helper'

describe Game do
  let(:default_decklist) {{"mana_bolt" => 5, "heal" => 3, "cantrip_bolt" => 4}}

  context "#initialize" do
    it "raises an error if given < 2 players" do
      expect{described_class.new([1], 1, 1, 10)}.to raise_error
    end

    it "raises an error if given > 2 players" do
      expect{described_class.new([1,2,3], 1, 1, 10)}.to raise_error
    end
  end

  context "with 2 players" do
    let(:players){
      [
        Player.new("player 1", default_decklist, 30, 4, 1),
        Player.new("player 2", default_decklist, 30, 4, 1)
      ]
    }
    let(:game) {described_class.new(players, 1, 1, 10)}

    context "#run_loop" do
      it "randomizes turn order" do
        allow(game).to receive(:game_over?).and_return(true)
        expect(game.players).to receive(:shuffle!)
        game.run_loop
      end

      context "game ends on turn 2" do
        before(:each) do
          allow(game).to receive(:game_over?) do
            game.turn_number >= 2
          end
        end

        it "initializes a new turn" do
          turn = double(Turn, run_loop: true)
          expect(Turn).to receive(:new).with(game, any_args).and_return(turn).at_least(:once)
          game.run_loop
        end

        it "alternates player turns" do
          turn = double(Turn, run_loop: true)
          expect(Turn).to receive(:new).with(game, game.players.first, game.players.last).once.and_return(turn)
          expect(Turn).to receive(:new).with(game, game.players.last, game.players.first).once.and_return(turn)
          game.run_loop
        end

        it "calls #run_loop on each turn" do
          turn = double(Turn)
          expect(Turn).to receive(:new).with(game, any_args).and_return(turn).at_least(:once)
          expect(turn).to receive(:run_loop).twice
          game.run_loop
        end

        it "outputs winning first player's name" do
          turn = double(Turn, run_loop: true)
          expect(Turn).to receive(:new).with(game, any_args).and_return(turn).at_least(:once)
          expect(players.last).to receive(:alive?).at_least(:once).and_return(false)
          expect{game.run_loop}.to output(/#{players.first.name} is victorious!/).to_stdout
        end

        it "outputs winning second player's name" do
          turn = double(Turn, run_loop: true)
          expect(Turn).to receive(:new).with(game, any_args).and_return(turn).at_least(:once)
          expect(players.first).to receive(:alive?).at_least(:once).and_return(false)
          expect{game.run_loop}.to output(/#{players.last.name} is victorious!/).to_stdout
        end
      end
    end

    context "#game_over?" do
      it "returns false if all players are alive" do
        game.players.each do |player|
          expect(player).to receive(:alive?).and_return(true)
        end
        expect(game.game_over?).to be_falsey
      end

      it "returns true if one or more players are not alive" do
        expect(game.players.last).to receive(:alive?).and_return(false)
        expect(game.game_over?).to be_truthy
      end
    end
  end
end
