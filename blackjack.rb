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

def check_win hand_score

  if hand_score < 21
    puts "you win :)"
  elsif hand_score == 21
    puts "blackjack :D"
  else
    puts "sorry, loser :("
  end

end

def game_play

  my_hand = player
  my_score = score my_hand

  output my_hand, my_score

  while keep_playing? my_score
    my_hand << hit
    my_score = score my_hand
    output my_hand, my_score
  end 

  return check_win my_score

end

game_play
