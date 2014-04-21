#Dealer class

require '/Users/jules/Dropbox/code/ruby/blackjack/Card'
require '/Users/jules/Dropbox/code/ruby/blackjack/Hand'

class Dealer
  attr_accessor :hand, :score

  def initialize
    @hand = Hand.new
    @score = update_score
  end

  def start_to_s
    puts "\nDealer shows the: "
    self.hand.cards[0].to_s
  end

  def hit_to_s
    puts "\nDealer turns over the: "
    self.hand.cards[-1].to_s
    puts "for a score of #{self.update_score}"
  end

  def to_s
    puts "\nDealer's hand: "
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

  def play_hand
    while self.update_score < 17
      self.hand.hit
      self.hit_to_s
    end
  end
end