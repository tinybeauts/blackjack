# BASIC BLACKJACK
# assume - suit irrelevant; infinite decks

CARDS = [2, 3, 4, 5, 6, 7, 8, 9, "J", "Q", "K", "A"]

# Step 1: deal 2 cards to player

def player

  my_hand = Array.new(2) { |i|  CARDS.sample }
  return my_hand

end

# Step 2: determine score of hand

def score hand

  my_total = 0
  aces = 0
  
  hand.each do |card|
    if card == "J" or card == "Q" or card == "K"
      my_total += 10
    elsif card == "A"
      aces += 1
      my_total += 11
    else
      my_total += card
    end 
  end

  while aces > 0
    if my_total > 21
      my_total -= 10
      aces -= 1
    else
      aces -= 1
    end
  end

  return my_total
end

# Step 3: hit or stand


def output my_hand, my_score

  puts "Your hand: #{my_hand.join(', ')}"
  puts "Your score: #{my_score}"

end

def hit

  return CARDS.sample

end

def keep_playing? my_score

  puts "Do you want to hit or stand?"

  response = gets.chomp.downcase
  
  return true if response.include? "h"

end

# Step 4: add dealer

def dealer

  Array.new(2) { |i|  CARDS.sample }

end

def dealer_play d_hand

  d_score = score d_hand

  while d_score < 17
    d_hand << hit
    d_score = score d_hand
  end

  return d_hand

end

def game_play

  my_hand = player
  my_score = score my_hand
  dealer_hand = dealer_play dealer
  dealer_score = score dealer_hand

  output my_hand, my_score

  while keep_playing? my_score
    my_hand << hit
    my_score = score my_hand
    output my_hand, my_score
  end 

  return check_win my_score, dealer_score

end

def check_win player_score, dealer_score

  if dealer_score > 21 or (dealer_score < 21 and player_score > dealer_score and player_score <= 21)
    puts "you win :)"
  elsif dealer_score == player_score
    puts "tie!"
  elsif player_score == 21
    puts "blackjack :D"
  elsif player_score > 21
    puts "busted :("
  else
    puts "you lose :("
  end
  
  puts player_score
  puts dealer_score

end

game_play
