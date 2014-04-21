# Hand class
require '/Users/jules/Dropbox/code/ruby/blackjack/Card'

class Hand
  attr_reader :cards, :total

  def initialize
    @cards = [Card.new, Card.new]
    @total = total
  end

  def total
    hand_total = self.cards.inject(0) { |sum, card| sum += card.to_i }
    aces = self.cards.count { |card| card.is_ace? }
  
    while hand_total > 21 && aces > 0
      hand_total -= 10
      aces -= 1
    end

    return hand_total
  end

  def hit
    self.cards << Card.new
  end
end