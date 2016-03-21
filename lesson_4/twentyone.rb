FULL_DECK = { hearts:   { "ace": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7,
                          "eight": 8, "nine": 9, "ten": 10, "jack": 10, "queen": 10, "king": 10 },
              diamonds: { "ace": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7,
                          "eight": 8, "nine": 9, "ten": 10, "jack": 10, "queen": 10, "king": 10 },
              spades:   { "ace": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7,
                          "eight": 8, "nine": 9, "ten": 10, "jack": 10, "queen": 10, "king": 10 },
              clubs:    { "ace": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7,
                          "eight": 8, "nine": 9, "ten": 10, "jack": 10, "queen": 10, "king": 10 }
            }.freeze

MAX = 21
DEALER_HIT_CAP = MAX - 4
ROUNDS = 2
WIDTH = 80

player_score = 0
dealer_score = 0

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  new_deck = []
  FULL_DECK.each do |_suit, cards|
    new_deck << cards.keys
  end
  new_deck = new_deck.flatten!.map!(&:to_s).shuffle
end

def deal(deck)
  player_hand = deck.pop(2)
  dealer_hand = deck.pop(2)
  return player_hand, dealer_hand
end

def ace?(hand)
  hand.include?("ace")
end

def calculate_card_value(card)
  FULL_DECK[:hearts][card.to_sym]
end

def calculate_hand_value(hand)
  hand_value = 0
  hand.each do |card|
    hand_value += calculate_card_value(card)
  end
  if ace?(hand) && hand_value < MAX
    hand_value += 10 unless (hand_value + 10) > MAX
  end
  hand_value
end

def hit(deck, hand)
  hand << deck.pop
end

def busted?(hand)
  calculate_hand_value(hand) > MAX
end

def detect_result(player_hand, dealer_hand)
  player_total = calculate_hand_value(player_hand)
  dealer_total = calculate_hand_value(dealer_hand)

  if player_total > MAX
    :player_busted
  elsif dealer_total > MAX
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def update_score(player_hand, dealer_hand, player_score, dealer_score)
  result = detect_result(player_hand, dealer_hand)

  case result
  when :player_busted
    dealer_score += 1
  when :dealer_busted
    player_score += 1
  when :player
    player_score += 1
  when :dealer
    dealer_score += 1
  end
  return player_score, dealer_score
end

def display_result(player_hand, dealer_hand)
  result = detect_result(player_hand, dealer_hand)

  case result
  when :player_busted
    prompt "YOU BUSTED! The Dealer wins this round."
  when :dealer_busted
    prompt "THE DEALER BUSTED! You win this round!"
  when :player
    prompt "YOU WIN!"
  when :dealer
    prompt "THE DEALER WINS."
  when :tie
    prompt "It's a tie..."
  end
end

def reveal_cards(player_hand, dealer_hand, player_total, dealer_total)
  puts ""
  prompt "LET'S COMPARE HANDS..."
  puts ""
  prompt "Player holds #{player_hand.join(', ')}.".ljust(WIDTH / 2) + "TOTAL = #{player_total}".rjust(WIDTH / 5)
  prompt "Dealer holds #{dealer_hand.join(', ')}.".ljust(WIDTH / 2) + "TOTAL = #{dealer_total}".rjust(WIDTH / 5)
  puts ""
end

def play_again?
  puts "============================="
  prompt "Would you like to play again?"
  answer = gets.chomp
  system 'clear'
  answer.downcase.start_with?("y")
end

system 'clear'
puts "WELCOME TO #{MAX}!".center(WIDTH * 0.75)
puts "The first to win #{ROUNDS} rounds wins the game.".center(WIDTH * 0.75)
puts ""

loop do
  shuffled_deck = initialize_deck
  player_hand = []
  dealer_hand = []

  # Initial deal
  player_hand, dealer_hand = deal(shuffled_deck)
  player_total = calculate_hand_value(player_hand)
  dealer_total = calculate_hand_value(dealer_hand)

  prompt "Player: #{player_score}".ljust(WIDTH / 2) + "Dealer: #{dealer_score}".rjust(WIDTH / 5)
  puts ""

  if player_score == ROUNDS
    prompt "Congratulations! You won #{ROUNDS} rounds against the Dealer. Nice work kid!"
    break
  elsif dealer_score == ROUNDS
    prompt "Sorry kid, the Dealer has won #{ROUNDS} rounds. I advise that you stay away from Vegas!"
    break
  end

  prompt "You hold: #{player_hand[0]} and #{player_hand[1]} for a total of #{player_total}."
  prompt "The Dealer holds: #{dealer_hand[0]} and ?"

  # Player turn
  loop do
    prompt "Would you like to (h)it or (s)tay?"
    answer = gets.chomp
    break if answer.downcase.start_with?("s")
    hit(shuffled_deck, player_hand)
    player_total = calculate_hand_value(player_hand)
    prompt "You chose to hit!"
    prompt "You now hold: #{player_hand.join(', ')}, for a total of #{player_total}." unless busted?(player_hand)
    break if busted?(player_hand)
  end

  if busted?(player_hand)
    reveal_cards(player_hand, dealer_hand, player_total, dealer_total)
    display_result(player_hand, dealer_hand)
    player_score, dealer_score = update_score(player_hand, dealer_hand, player_score, dealer_score)
    if player_score < ROUNDS && dealer_score < ROUNDS
      play_again? ? next : break
    else
      next
    end
  else
    prompt "You stay at #{player_total}"
    puts " "
  end

  # Dealer turn
  prompt "DEALER'S TURN..."
  puts ""
  loop do
    if dealer_total < DEALER_HIT_CAP
      hit(shuffled_deck, dealer_hand)
      dealer_total = calculate_hand_value(dealer_hand)
      prompt "The Dealer hits..."
      prompt "and now holds: #{dealer_hand.join(', ')}, for a total of #{dealer_total}." unless busted?(dealer_hand)
      break if busted?(dealer_hand)
    elsif dealer_total >= DEALER_HIT_CAP
      prompt "The Dealer stays at #{dealer_total}"
      break
    end
  end

  if busted?(dealer_hand)
    reveal_cards(player_hand, dealer_hand, player_total, dealer_total)
    display_result(player_hand, dealer_hand)
    player_score, dealer_score = update_score(player_hand, dealer_hand, player_score, dealer_score)
    if player_score < ROUNDS && dealer_score < ROUNDS
      play_again? ? next : break
    else
      next
    end
  end

  # If both Dealer and Player stay, compare hands
  reveal_cards(player_hand, dealer_hand, player_total, dealer_total)
  display_result(player_hand, dealer_hand)
  puts ""
  player_score, dealer_score = update_score(player_hand, dealer_hand, player_score, dealer_score)

  if player_score < ROUNDS && dealer_score < ROUNDS
    break unless play_again?
  else
    next
  end
end

prompt "Thanks for playing 21. Goodbye!"
puts ""
