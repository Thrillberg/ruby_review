#Game [has a human object and computer object]
#  - play
#  - welcome_message [puts string]
#  - goodbye_message [puts string]
#  - play_again? [returns string - "n" or "y"]

#Round
#  - play [returns string - winner name or "draw"]
#  - humans_turn [returns string of weapon name]
#  - computers_turn [returns string of weapon name]
#  - determine_winner [returns string of winner]

#Player [has wins integer]
#  - wins [returns number of wins accumulated]
#  Human
#    - choose_weapon [returns string with interpolated return from weapon object]
#  Computer
#    - random_weapon [returns string with interpolated return from weapon object]

#Weapon
#  - select_weapon [returns string of "rock", "paper", or "scissors"]

class Round
  def initialize(human, computer)
    @human = human
    @computer = computer
  end

  def play
    humans_turn
    computers_turn
    determine_winner
  end

  def humans_turn
    @human.choose_weapon
  end

  def computers_turn
    @computer.choose_weapon
  end

  def determine_winner
    if @human.weapon == @computer.weapon
      "draw"
    elsif @human.weapon == 'rock' && @computer.weapon == 'paper'
      'computer'
    elsif @human.weapon == 'rock' && @computer.weapon == 'scissors'
      'human'
    elsif @human.weapon == 'paper' && @computer.weapon == 'rock'
      'human'
    elsif @human.weapon == 'paper' && @computer.weapon == 'scissors'
      'computer'
    elsif @human.weapon == 'scissors' && @computer.weapon == 'rock'
      'computer'
    elsif @human.weapon == 'scissors' && @computer.weapon == 'paper'
      'human'
    end
  end
end

class Player
  attr_accessor :wins, :weapon

  def initialize
    @wins = 0
    @weapon = ""
  end
end

class Human < Player
  def choose_weapon
    puts "Choose your weapon: (r/p/s)"
    weapon = gets.chomp.downcase
    @weapon = Weapon.new.select_weapon(weapon)
    puts "You chose #{@weapon}."
  end
end

class Computer < Player
  def choose_weapon
    @weapon = Weapon.new.select_weapon(["r", "p", "s"].sample)
    puts "The computer chose #{@weapon}."
  end
end

class Weapon
  def select_weapon(weapon)
    if weapon == "r"
      "rock"
    elsif weapon == "p"
      "paper"
    elsif weapon == "s"
      "scissors"
    end
  end
end

class Game
  REQUIRED_WINS = 2

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    welcome_message
    loop do
      winner = Round.new(@human, @computer).play
      puts "The #{winner} won."

      add_wins(winner)
      puts "You have #{@human.wins} wins and the computer has #{@computer.wins} wins."

      break if @human.wins == REQUIRED_WINS || @computer.wins == REQUIRED_WINS
      answer = play_again?
      break if answer == 'n'
    end
    goodbye_message
  end

  def welcome_message
    puts "Welcome to Rock Paper Scissors!"
  end

  def goodbye_message
    puts "Thanks for playing!"
  end

  def play_again?
    puts "Do you want to play again? (y/n)"
    loop do
      answer = gets.chomp
      return answer if answer == 'y' || answer == 'n'
      puts "That's an invalid answer. Do you want to play again?"
    end
  end

  def add_wins(winner)
    if winner == "human"
      @human.wins += 1
    elsif winner == "computer"
      @computer.wins += 1
    end
  end
end

Game.new.play
