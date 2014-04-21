# Card class
# assume - suit irrelevant; infinite decks

CARDS = [2, 3, 4, 5, 6, 7, 8, 9, "Jack", "Queen", "King", "Ace"]
SUITS = ["Clubs", "Diamonds", "Hearts", "Spades"]

class Card
  attr_reader :symbol, :suit

  def initialize
    @symbol = CARDS.sample
    @suit = SUITS.sample
  end

  def to_s
    puts "#{self.symbol} of #{self.suit}"
  end

  def to_i
    if self.symbol == "Jack" or self.symbol == "Queen" or self.symbol == "King"
      return 10
    elsif self.symbol == "Ace"
      return 11
    else
      return self.symbol
    end
  end

  def is_ace?
    self.symbol == "Ace"
  end
end