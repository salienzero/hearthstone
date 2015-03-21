#!/usr/bin/env ruby

require "yaml"

GAME_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), "config", "game_config.yml"))
DEFAULT_DECKLIST = YAML.load_file(File.join(File.dirname(__FILE__), "config", "default_deck.yml"))
CARDS = YAML.load_file(File.join(File.dirname(__FILE__), "config", "cards.yml"))

# Load all models
model_path = File.join(File.dirname(__FILE__), "models", "**", "*.rb")
Dir.glob(model_path).each { |f| require f }


player1 = Player.new(DEFAULT_DECKLIST, GAME_CONFIG["starting_hp"], GAME_CONFIG["starting_hand_size"])
player2 = Player.new(DEFAULT_DECKLIST, GAME_CONFIG["starting_hp"], GAME_CONFIG["starting_hand_size"])

puts "p1 deck:"
player1.deck.cards.each do |card|
  puts card.name
end

puts "p1 hand:"
player1.hand.each do |card|
  puts card.name
end

puts "p2 deck:"
player2.deck.cards.each do |card|
  puts card.name
end

puts "p2 hand:"
player2.hand.each do |card|
  puts card.name
end

