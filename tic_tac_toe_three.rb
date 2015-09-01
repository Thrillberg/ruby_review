#Board
#  - display
#  - place_marker

#Player
#  Human
#    - move [returns a square object]
#  Computer

#Square

#Game
#  - play
#  - welcome_message [puts string]
#  - display_board [puts an instance of board object]
#  - game_ended [return "computer", "human", "draw", or nil]
#  - goodbye_message [puts string]


class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  def initialize
    @board = {}
    (1..9).each { |num| @board[num] = Square.new }
  end

  def display
    puts " #{@board[1].marker} | #{@board[2].marker} | #{@board[3].marker}"
    puts "-----------"
    puts " #{@board[4].marker} | #{@board[5].marker} | #{@board[6].marker}"
    puts "-----------"
    puts " #{@board[7].marker} | #{@board[8].marker} | #{@board[9].marker}"
  end

  def get_square(square)
    @board[square]
  end

  def empty_squares
    empty_squares = []
    (1..9).each do |num|
      if @board[num].marker == Square::INITIAL_MARKER
        empty_squares << @board[num]
      end
    end
    empty_squares
  end

  def result
    WINNING_LINES.each do |line|
      human_squares = 0
      computer_squares = 0
      line.each do |square|
        if @board[square].marker == "X"
          human_squares += 1
        elsif @board[square] == "O"
          computer_squares +=1
        end
      end
      if human_squares == 3
        return "human"
      elsif computer_squares == 3
        return "computer"
      elsif empty_squares.count == 0
        return "draw"
      end
    end
    return nil
  end
end

class Human
  PLAYER_MARKER = "X"
  def move(board)
    placement = nil
    loop do
      puts "Where would you like to play? (1-9)"
      placement = gets.chomp.to_i
      break if board.get_square(placement).marker == Square::INITIAL_MARKER
      puts "That is an invalid answer."
    end
    board.get_square(placement).marker = PLAYER_MARKER
  end
end

class Computer
  COMPUTER_MARKER = "O"
  def move(board)
    board.empty_squares.sample.marker = COMPUTER_MARKER
  end
end

class Square
  INITIAL_MARKER = " "
  attr_accessor :marker

  def initialize
    @marker = INITIAL_MARKER
  end

end

class Game
  attr_accessor :human, :computer, :board

  def initialize
    @human = Human.new
    @computer = Computer.new
    @board = Board.new
  end

  def play
    welcome_message
    loop do
      board.display
      human.move(board)
      break if display_result(board)
      computer.move(board)
      break if display_result(board)
    end
    goodbye_message
  end

  def display_result(board)
    if board.result == "computer"
      board.display
      puts "The computer won!"
      return "computer"
    elsif board.result == "human"
      board.display
      puts "You won!"
      return "human"
    else
      return nil
    end
  end

  def welcome_message
    puts "Welcome to Tic Tac Toe!"
  end

  def goodbye_message
    puts "Thanks for playing!"
  end
end

Game.new.play
