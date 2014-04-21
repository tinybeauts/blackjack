# Game class
require '/Users/jules/Dropbox/code/ruby/blackjack/Card'
require '/Users/jules/Dropbox/code/ruby/blackjack/Hand'
require '/Users/jules/Dropbox/code/ruby/blackjack/Player'
require '/Users/jules/Dropbox/code/ruby/blackjack/Dealer'

class Game
  attr_accessor :min_bet, :player, :dealer, :hand_count

  def initialize
    @min_bet = 1
    @player = Player.new
    @dealer = Dealer.new
    @hand_count = 0
    welcome
  end

  def play_options
    puts "\nYou can:"
    puts "[1] Hit"
    puts "[2] Stand"
    puts "[3] Double down"
    puts "[4] Split"
    puts "[5] Surrender"
    puts "What would you like to do?"
    print "> "
    
    choice = gets.chomp.downcase
    exit_text if quit? choice

    if choice.include? "h" or choice.include? "1"
      hit
      print_hand_status
      play_options
    elsif choice.include? "stand" or choice.include? "2"
      stand
    elsif choice.include? "double" or choice.include? "3"
      double_down
    elsif choice.include? "split" or choice.include? "4"
      split
    elsif choice.include? "surrender" or choice.include? "5"
      surrender
    else
      puts "I'm sorry, that wasn't a valid choice! Try harder this time."
      play_options
    end
  end

  def game_options
    puts "\nYou can:"
    puts "[1] Play a hand"
    puts "[2] Leave the table"
    puts "What would you like to do?"
    print "> "

    choice = gets.chomp.downcase

    if choice.include? "p" or choice.include? "1"
      play_a_hand
    elsif quit?(choice) or choice.include? "2" or choice.include? "leave"
      exit_text
    else
      puts "I'm sorry, please make another choice."
      game_options
    end

  end

  def welcome
    puts "Welcome to BlackJack!"
    puts "The minimum bet at this table is $#{self.min_bet}"
    puts "So pony up, suckers!"
    game_options
  end

  def exit_text
    puts "\nOkay! Have a great day :D"
    puts "Come back soon!"
    exit
  end

  def quit? choice
    choice == "exit" or choice == "quit" or choice == "q"
  end

  def play_a_hand
    deal_new_hands if self.hand_count != 0

    puts "\nYou have $#{self.player.dollars} available to bet."
    self.player.bet = place_a_bet

    print_hand_status
    play_options
  end

  def print_hand_status
    puts "\nYou have $#{self.player.dollars} and your current bet is $#{self.player.bet}"
    self.dealer.start_to_s
    self.player.hand_to_s
  end

  def deal_new_hands
    self.player.hand = Hand.new
    self.dealer.hand = Hand.new
  end

  def place_a_bet
    puts "What would you like to bet?"
    print "> $"

    my_bet = gets.chomp.downcase
    exit_text if quit? my_bet

    if valid_bet? my_bet.to_i
      return my_bet.to_i
    else
      puts "Please enter a postive integer bet larger than $#{self.min_bet} :)"
      place_a_bet
    end

  end

  def valid_bet? a_bet
    a_bet >= self.min_bet
  end

  def hit
    self.player.hand.hit
  end

  def stand
    self.dealer.to_s
    self.dealer.play_hand
    determine_winner self.dealer.hand, self.player.hand    

    next_hand
  end

  def determine_winner dealer_hand, player_hand
    self.hand_count += 1

    if (blackjack? player_hand) && !(blackjack? dealer_hand)
      player_gets_blackjack
    elsif dealer_hand.total > 21
      player_wins
    elsif player_hand.total > dealer_hand.total && player_hand.total <= 21
      player_wins
    elsif player_hand.total == dealer_hand.total
      if player_hand.total < 21
        tie
      elsif (blackjack? dealer_hand) && !(blackjack? player_hand)
        player_loses
      else
        player_wins
      end
    else
      player_loses
    end
  end

  def blackjack? a_hand
    a_hand.cards.length == 2 && a_hand.total == 21
  end

  def player_wins
    self.player.dollars += self.player.bet
    puts "\nYou won that hand!"
    puts "You made $#{self.player.bet} and now you have $#{self.player.dollars}."
  end

  def player_gets_blackjack
    self.player.dollars += self.player.bet * 1.5
    puts "\nYou won BLACKJACK that hand!"
    puts "You made $#{self.player.bet * 1.5} and now you have $#{self.player.dollars}."
  end

  def player_loses
    self.player.dollars -= self.player.bet
    puts "\nYou lost that hand ;("
    puts "You lost $#{self.player.bet} and now you have $#{self.player.dollars}."
  end

  def tie
    puts "\nIt was a tie?!?"
    puts "You get $#{self.player.bet} back and you still have $#{self.player.dollars}."
  end

  def next_hand
    if self.player.dollars > 0
      puts "You have $#{self.player.dollars} left."
      game_options
    else
      puts "I'm so sorry, but you're out of money!"
      puts "Please call your mom to come pick you up."
    end
  end

  def double_down
    if (self.player.dollars - self.player.bet) >= self.player.bet
      puts "\nYou can bet up to $#{self.player.bet} more."
    else
      puts "\nYou can bet up to $#{self.player.dollars - self.player.bet} more."
    end

    self.player.bet += double_down_bet
    hit
    stand
  end

  def double_down_bet
    puts "What would you like to bet?"
    print "> $"

    my_bet = gets.chomp.downcase
    exit_text if quit? my_bet

    if valid_dd_bet? my_bet.to_i
      return my_bet.to_i
    else
      puts "You can't bet that much. I'm betting $#{self.player.dollars - self.player.bet} for you instead."
      return (self.player.dollars - self.player.bet).to_i
    end
  end

  def valid_dd_bet? new_bet
    new_bet <= (self.player.dollars - self.player.bet)
  end

  def split
    if self.player.hand.cards.length > 2
      puts "\nYou can't split this hand, it's too late!"
    elsif self.player.hand.cards[0].symbol != self.player.hand.cards[1].symbol
      puts "\nYou can't split this hand, the cards don't have the same value!"
    elsif (self.player.dollars - self.player.bet) <= self.player.bet
      puts "\nYou can't split this hand, you don't have enough money $$$"
    else
      split_hand = [self.player.hand, Hand.new]
      copy_card = split_hand[0].cards[1]
      second_copy_card = split_hand[1].cards[0]
      split_hand[0].cards[1] = second_copy_card
      split_hand[1].cards[0] = copy_card
      split_score = [split_hand[0].total, split_hand[1].total]

      print_split split_hand
      
      split_hand.each_with_index do |hand, index|
        if index == 0
          puts "\nFor your first hand, would you like to hit or stand?"
        else
          puts "\nFor your second hand, would you like to hit or stand?"
        end
        print "> "

        response = gets.chomp.downcase
        exit_text if quit? response
        
        while response.include? "h"
          hand.hit
          print "#{hand.cards[-1].to_s}"
          puts "Your score is now #{hand.total}."
          puts "Do you want to hit or stand?"
          print "> "
          response = gets.chomp.downcase
          exit_text if quit? response
        end
        split_hand[index] = hand
      end 
      
      self.dealer.to_s
      self.dealer.play_hand

      split_hand.each { |hand| determine_winner self.dealer.hand, hand }
      next_hand
    end 
  end

  def print_split split_hand
    split_hand.each_with_index do |hand, index|
      if index == 0
        puts "\nIn your first hand is the: "
      else
        puts "\nIn your second hand is the: "
      end
      cards_in_hand = hand.cards
      cards_in_hand.each_with_index do |card, card_index|
        print (card_index == cards_in_hand.length - 2) ? "and the #{card.to_s}" : card.to_s
      end
      puts "for a score of #{hand.total}"
    end
  end

  def surrender
    self.hand_count += 1
    puts "\nsad face!"
    self.player.dollars -= self.player.bet / 2.0
    puts "You have $#{self.player.dollars} left."
    game_options
  end
end

my_game = Game.new