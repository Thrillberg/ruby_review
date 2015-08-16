def choice_letter_to_word(choice)
  if choice == "r"
    choice = "rock"
  elsif choice == "p"
    choice = "paper"
  elsif choice == "sc"
    choice = "scissors"
  elsif choice == "sp"
    choice = "spock"
  elsif choice == "l"
    choice = "lizard"
  end
  choice
end

@comp_wins = 0
@user_wins = 0
@round = 1

def tie
  puts "It's a tie! Nobody wins."
  @round += 1
end

def user_wins
  @user_wins += 1
  @round += 1
  puts "Congratualtions, #{@name}! You won the match."
end

def comp_wins
  @comp_wins += 1
  @round += 1
  puts "Sorry, #{@name}, the computer won the match!"
end

def user_win_check
  if @user_wins == 4 && @comp_wins != 4
    puts "You've got four points. Almost there!"
  elsif @user_wins == 4 && @comp_wins == 4
    puts "Intense game!"
  elsif @user_wins == 5
    puts "Congratulations! #{@name} won the whole round!"
    @play_again = "n"
  end
end

def comp_win_check
  if @comp_wins == 4 && @user_wins != 4
    puts "The computer has four points. Better start winning!"
  elsif @comp_wins == 5
    puts "Sorry! The computer won the whole round!"
    @play_again = "n"
  end
end

puts "Welcome to Rock Paper Scissors Spock Lizard! Please enter your name."
@name = gets.chomp
puts "Thanks, #{@name}. We'll be playing until one player has won five games."
@play_again = "y"

until @play_again == "n"
  puts "------ Round #{@round} ------"
  puts "Which weapon do you choose? Please just type the first letter of the word (or 'sc' for scissors and 'sp' for spock)."
  puts "(r / p / sc / sp / l)"

  user_choice = gets.chomp.downcase
  unless /\A(?:r|p|sc|sp|l)\z/.match(user_choice)
    puts "Please choose an appropriate letter."
    break
  end

  if user_choice == "s"
    puts "Please be more specific. Enter 'sc' for scissors and 'sp' for spock."
    break
  end

  comp_choice = choice_letter_to_word(["r", "p", "sc", "sp", "l"].shuffle.pop)
  user_choice = choice_letter_to_word(user_choice)
  puts "You chose #{user_choice} and the computer chose #{comp_choice}."

  if user_choice == comp_choice
    tie
  elsif user_choice == "rock" && comp_choice == "paper"
    comp_wins
  elsif user_choice == "rock" && comp_choice == "scissors"
    user_wins
  elsif user_choice == "rock" && comp_choice == "lizard"
    user_wins
  elsif user_choice == "rock" && comp_choice == "spock"
    comp_wins
  elsif user_choice == "paper" && comp_choice == "rock"
    user_wins
  elsif user_choice == "paper" && comp_choice == "scissors"
    comp_wins
  elsif user_choice == "paper" && comp_choice == "spock"
    user_wins
  elsif user_choice == "paper" && comp_choice == "lizard"
    comp_wins
  elsif user_choice == "scissors" && comp_choice == "paper"
    user_wins
  elsif user_choice == "scissors" && comp_choice == "rock"
    comp_wins
  elsif user_choice == "scissors" && comp_choice == "lizard"
    user_wins
  elsif user_choice == "scissors" && comp_choice == "spock"
    comp_wins
  elsif user_choice == "lizard" && comp_choice == "spock"
    user_wins
  elsif user_choice == "lizard" && comp_choice == "paper"
    user_wins
  elsif user_choice == "lizard" && comp_choice == "rock"
    comp_wins
  elsif user_choice == "lizard" && comp_choice == "scissors"
    comp_wins
  elsif user_choice == "spock" && comp_choice == "scissors"
    user_wins
  elsif user_choice == "spock" && comp_choice == "rock"
    user_wins
  elsif user_choice == "spock" && comp_choice == "paper"
    comp_wins
  elsif user_choice == "spock" && comp_choice == "lizard"
    comp_wins
  end

  comp_win_check
  user_win_check
  puts "The computer has won #{@comp_wins} games and you have won #{@user_wins} games."

end
