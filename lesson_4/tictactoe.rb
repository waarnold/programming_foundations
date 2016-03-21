INITIAL_MARKER  = ' '.freeze
PLAYER_MARKER   = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze
WINNING_LINES   = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]].freeze
FIRST_PLAYER    = "choose".freeze

player_score    = 0
computer_score  = 0

def prompt(msg)
  puts "=> #{msg}"
end

def joinor(arr, delimiter=', ', word='or')
  arr[-1] = "#{word} #{arr.last}." if arr.size > 1
  arr.join(delimiter)
end

def display_board(brd, player_score, computer_score)
  system 'clear'
  puts "Player = #{PLAYER_MARKER}" + "Computer = #{COMPUTER_MARKER}".rjust(35)
  puts "Score = #{player_score}"   + "Score = #{computer_score}".rjust(36)
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def determine_first_player
  if FIRST_PLAYER == "choose"
    prompt "Who goes first: Player or Computer?"
    answer = gets.chomp
    return "player" unless answer.downcase.start_with?("c")
    return "computer"
  else
    FIRST_PLAYER
  end
end

def alternate_player(current_player)
  if current_player == "player"
    "computer"
  elsif current_player == "computer"
    "player"
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square: #{joinor(empty_squares(brd))}"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def find_at_risk_square(brd, marker)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(marker) == 2 &&
       brd.values_at(*line).count(INITIAL_MARKER) == 1
      return brd.keys.select { |num| line.include?(num) && brd[num] == INITIAL_MARKER }[0]
    end
  end
  nil
end

def computer_places_piece!(brd)
  if find_at_risk_square(brd, COMPUTER_MARKER)          ## The computer moves to win
    square = find_at_risk_square(brd, COMPUTER_MARKER)
    brd[square] = COMPUTER_MARKER
  elsif find_at_risk_square(brd, PLAYER_MARKER)         ## The computer blocks a threat
    square = find_at_risk_square(brd, PLAYER_MARKER)
    brd[square] = COMPUTER_MARKER
  elsif brd[5] == INITIAL_MARKER                        ## The computer defaults to the center square
    brd[5] = COMPUTER_MARKER
  else                                                  ## The computer randomly selects a square
    square = empty_squares(brd).sample
    brd[square] = COMPUTER_MARKER
  end
end

def place_piece!(brd, current_player)
  if current_player == "player"
    player_places_piece!(brd)
  elsif current_player == "computer"
    computer_places_piece!(brd)
  end
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def winner?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return "Player"
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return "Computer"
    end
  end
  nil
end

def update_score(brd, player_score, computer_score)
  if detect_winner(brd) == "Player"
    player_score += 1
  elsif detect_winner(brd) == "Computer"
    computer_score += 1
  end
  return player_score, computer_score
end

prompt "Welcome to Tic Tac Toe!"

loop do
  board = initialize_board
  current_player = determine_first_player

  loop do
    display_board(board, player_score, computer_score)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if winner?(board) || board_full?(board)
  end

  player_score, computer_score = update_score(board, player_score, computer_score)
  display_board(board, player_score, computer_score)

  if winner?(board)
    prompt "#{detect_winner(board)} won!"
  else
    prompt "It's a tie!"
  end

  if computer_score < 5 && player_score < 5
    prompt "Would you like to play again?"
    play_again = gets.chomp
    break unless play_again.downcase.start_with?("y")
  elsif computer_score == 5
    prompt "The computer has won five rounds! Better luck next time :("
    break
  elsif player_score == 5
    prompt "You have won five rounds against the computer! Great job!"
    break
  end

end

prompt "Thank you for playing Tic Tac Toe! Peace out."
