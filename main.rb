#!/usr/bin/env ruby

require "yaml"

GAME_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), "config", "game_config.yml"))
DEFAULT_DECKLIST = YAML.load_file(File.join(File.dirname(__FILE__), "config", "default_deck.yml"))
CARDS = YAML.load_file(File.join(File.dirname(__FILE__), "config", "cards.yml"))

# Load all models
model_path = File.join(File.dirname(__FILE__), "models", "**", "*.rb")
Dir.glob(model_path).each { |f| require f }

players = []
players << Player.new("Player 1", DEFAULT_DECKLIST, GAME_CONFIG["starting_hp"], GAME_CONFIG["starting_hand_size"], GAME_CONFIG["empty_deck_hp_loss"])
players << Player.new("Player 2", DEFAULT_DECKLIST, GAME_CONFIG["starting_hp"], GAME_CONFIG["starting_hand_size"], GAME_CONFIG["empty_deck_hp_loss"])

game = Game.new(players, GAME_CONFIG["starting_mana"], GAME_CONFIG["mana_per_turn"], GAME_CONFIG["max_mana"])

game.run_loop
