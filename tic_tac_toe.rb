INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def display_board(brd)
  system 'clear'
  puts "You're #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts "       #{brd[1]} | #{brd[2]} | #{brd[3]}
      -----------
       #{brd[4]} | #{brd[5]} | #{brd[6]}
      -----------
       #{brd[7]} | #{brd[8]} | #{brd[9]}"
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(arr, delimiter, word='or')
  arr[-1] = "#{word} #{arr.last}" if arr.size > 1
  arr.join(delimiter)
end

def player_places_piece!(brd)
  square = ''
  loop do
    puts "Choose a square (#{joinor(empty_squares(brd), ', ')}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    puts "Sorry, that's not a valid choice."
  end

  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  square = nil
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd)
    break if square
  end

  if !square
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd) 
  WINNING_LINES.each do |line|
    if brd[line[0]] == PLAYER_MARKER &&
       brd[line[1]] == PLAYER_MARKER &&
       brd[line[2]] == PLAYER_MARKER
      return 'User'
    end

    if brd[line[0]] == COMPUTER_MARKER &&
       brd[line[1]] == COMPUTER_MARKER &&
       brd[line[2]] == COMPUTER_MARKER
      return 'Computer'
    end
  end
  nil
end

def find_at_risk_square(line, board)
  if board.values_at(*line).count(PLAYER_MARKER) == 2
    board.select{ |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  else
    nil
  end
end

@user_wins = 0
@comp_wins = 0

loop do
  board = initialize_board
  display_board(board)

  loop do
    display_board(board)

    player_places_piece!(board)
    break if someone_won?(board) || board_full?(board)

    computer_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    if detect_winner(board) == 'User'
      @user_wins += 1
      puts "#{detect_winner(board)} won!"
    elsif detect_winner(board) == 'Computer'
      @comp_wins += 1
      puts "#{detect_winner(board)} won!"
    end
  else
    puts "It's a tie!"
  end

  puts "The score is #{@user_wins} wins for the user and #{@comp_wins} wins for the computer. First to five wins the game."
  if @user_wins == 5
    break
  elsif @comp_wins == 5
    break
  end

  puts "Would you like to play again? (y/n)"
  play_again = gets.chomp.downcase
  break if play_again == "n"
end

puts "Thanks for playing!"
