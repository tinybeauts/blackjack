#Player class
require '/Users/jules/Dropbox/code/ruby/blackjack/Card'
require '/Users/jules/Dropbox/code/ruby/blackjack/Hand'

class Player
  attr_accessor :dollars, :hand, :score, :bet

  def initialize
    @dollars = 100
    @hand = Hand.new
    @score = update_score
    @bet = 0
  end

  def hand_to_s
    puts "\nIn your hand is the: "
    the_cards = self.hand.cards
    the_cards.each_with_index do |card, index|
      print (index == the_cards.length - 2) ? "and the #{card.to_s}" : card.to_s
    end
    puts "for a score of #{self.update_score}"
  end

  def update_score
    self.score = self.hand.total
    return self.hand.total
  end
end