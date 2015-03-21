class Card
  attr_accessor :name, :cost, :damage, :heal, :draw, :mana, :message

  def initialize(card_definition)
    @name = card_definition["name"]
    @cost = card_definition["cost"]
    @damage = card_definition["damage"]
    @heal = card_definition["heal"]
    @draw = card_definition["draw"]
    @mana = card_definition["mana"]
    @message = card_definition["message"]
  end
end
