VALID_CHOICES = { r: "rock",
                  p: "paper",
                  sc: "scissors",
                  l: "lizard",
                  sp: "spock"
                }.freeze

player_score = 0
computer_score = 0

def prompt(message)
  puts("=> #{message}")
end

def win?(first, second)
  (first == 'rock') && %w(scissors lizard).include?(second)     ||
    (first == 'paper') && %w(rock spock).include?(second)       ||
    (first == 'scissors') && %w(paper lizard).include?(second)  ||
    (first == 'lizard') && %w(spock paper).include?(second)     ||
    (first == 'spock') && %w(rock scissors).include?(second)
end

def display_results(player, computer)
  if win?(player, computer)
    prompt("You won a round!")
  elsif win?(computer, player)
    prompt("The computer won this round... :(")
  else
    prompt("You tied with the computer!")
  end
end

prompt("Welcome to Rock, Paper, Scissors, Lizard, Spock!")

loop do
  choice = ''
  loop do
    prompt("Choose one: ")
    VALID_CHOICES.each { |key, value| print prompt("#{value} (#{key})") }

    choice = gets.chomp

    if VALID_CHOICES.value?(choice)
      break
    elsif VALID_CHOICES.key?(choice.to_sym)
      choice = VALID_CHOICES[choice.to_sym]
      break
    else
      prompt("That's not a valid choice.")
    end
  end

  computer_choice = VALID_CHOICES.values.sample

  prompt("You chose #{choice}; The computer chose #{computer_choice}.")

  display_results(choice, computer_choice)

  if win?(choice, computer_choice)
    player_score += 1
  elsif win?(computer_choice, choice)
    computer_score += 1
  end

  prompt("Player: #{player_score}/5, Computer: #{computer_score}/5")

  if player_score >= 5
    prompt("PLAYER WINS! Congratulations!")
    break
  elsif computer_score >= 5
    prompt("COMPUTER WINS! Better luck next time.")
    break
  else
    prompt("Would you like to play again? Y/N")
    play_again = gets.chomp
    break unless play_again.downcase.start_with?('y')
  end
end

prompt("Thank you for playing. Goodbye!")
