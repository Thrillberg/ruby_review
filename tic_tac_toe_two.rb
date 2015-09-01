WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

class Board
  def initialize
    @board_values = {}
    (1..9).each { |square| @board_values[square] = Square.new }
    @board_values
  end

  def get_square_at(key)
    @board_values[key]
  end

  def update_square(key, marker)
    @board_values[key].marker = marker
  end

  def square_full?(square)
    @board_values[square].marker != Square::INITIAL_MARKER
  end

  def someone_won?
    WINNING_LINES.each do |line|
      if @board_values[line[0]].marker == TTTGame::HUMAN_MARKER &&
         @board_values[line[1]].marker == TTTGame::HUMAN_MARKER &&
         @board_values[line[2]].marker == TTTGame::HUMAN_MARKER
        return 'Human'
      end

      if @board_values[line[0]].marker == TTTGame::COMPUTER_MARKER &&
         @board_values[line[1]].marker == TTTGame::COMPUTER_MARKER &&
         @board_values[line[2]].marker == TTTGame::COMPUTER_MARKER
        return 'Computer'
      end
    end
    nil
  end

  def tie?
    true unless @board_values.any? { |value| value[1].marker == " " }
  end

  def find_at_risk_square(line, board)
    if @board_values.select { |k, v| line.include?(k) && v.marker == TTTGame::HUMAN_MARKER }.count == 2
      @board_values.select{ |k, v| line.include?(k) && v.marker == Square::INITIAL_MARKER }.keys.first
    else
      nil
    end
  end

  def find_winning_square(line, board)
    if @board_values.select { |k, v| line.include?(k) && v.marker == TTTGame::COMPUTER_MARKER }.count == 2
      @board_values.select{ |k, v| line.include?(k) && v.marker == Square::INITIAL_MARKER }.keys.first
    else
      nil
    end
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @human_wins = 0
    @computer_wins = 0
  end

  def clear
    system 'clear'
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing!"
  end

  def display_board
    clear
    puts "You're #{human.marker} and computer is #{computer.marker}."
    puts " #{board.get_square_at(1)} | #{board.get_square_at(2)} | #{board.get_square_at(3)}"
    puts "-----------"
    puts " #{board.get_square_at(4)} | #{board.get_square_at(5)} | #{board.get_square_at(6)}"
    puts "-----------"
    puts " #{board.get_square_at(7)} | #{board.get_square_at(8)} | #{board.get_square_at(9)}"
  end

  def human_moves
    puts "It's your move!"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if (1..9).include?(square) && !board.square_full?(square)
      puts "Sorry, not a valid choice!"
    end
    board.update_square(square, human.marker)
  end

  def computer_moves
    puts "The computer is moving..."
    square = nil

    WINNING_LINES.each do |line|
      square = board.find_winning_square(line, board)
      break if square
    end

    if !square
      WINNING_LINES.each do |line|
        square = board.find_at_risk_square(line, board)
        break if square
      end
    end

    if !square
      square = (1..9).to_a.select { |num| !board.square_full?(num) }.sample
        #.to_a.sample unless board.square_full?(square)
    end

    board.update_square(square, computer.marker)
  end

  def display_result
    display_board
    if board.someone_won? == 'Human'
      puts "You won."
    elsif board.someone_won? == 'Computer'
      puts "Sorry, you lost!"
    else
      puts "The board is full!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end
    answer == 'y'
  end

  def reset
    
  end

  def play
    loop do
      display_welcome_message
      display_board
      loop do
        display_board
        human_moves
        display_board
        
        if board.tie? || board.someone_won?
          display_result
          if board.someone_won? == "Human"
            @human_wins += 1
            if @human_wins == 5
              puts "Congratulations, you won!" 
              abort
            end
            puts @human_wins
            puts @computer_wins
          end
          break unless play_again?
          reset
        end

        computer_moves
        display_board
        if board.tie? || board.someone_won?
          display_result
          if board.someone_won? == "Computer"
            @computer_wins += 1
            if @computer_wins == 5
              puts "Sorry, computer won."
              abort
            end
            puts @human_wins
            puts @computer_wins
          end
          break unless play_again?
          reset
        end
      end
    end
  end
end

# we'll kick off the game like this
game = TTTGame.new
game.play
