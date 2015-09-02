# randomly generates the board
# while true
#   draw the board
#   apply the rules on the board to get a new board # end

class Game
  def start
    board = Board.new(24, 80)
    initialize_board(board)
    i = 0
    while true
      system 'clear'
      puts "Generation #{i}"
      board.draw_board
      board = evolve(board)
      i+=1
      sleep 0.1
    end
  end

  def initialize_board(board)
    (0..board.rows-1).each do |row|
      (0..board.columns-1).each do |column|
        board.cells[row][column] = rand > 0.5 ? 1 : 0
      end
    end
  end

  def evolve(board)
    new_board = Board.new(24, 80)
    (0..board.rows-1).each do |row|
      (0..board.columns-1).each do |column|
        current_status = board.cells[row][column]
        n = board.living_neighbors(row, column)
        if n < 2
          new_status = 0
        elsif n == 2 && current_status == 0
          new_status = 0
        elsif n == 2 && current_status == 1
          new_status = 1
        elsif n == 3
          new_status = 1
        else
          new_status = 0
        end
        new_board.cells[row][column] = new_status
      end
    end
    new_board
  end
end

class Board
  attr_reader :rows, :columns, :cells

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @cells = Array.new(rows) {Array.new(columns)}
  end

  def living_neighbors(x, y)
    around_coordinates = [[x-1, y-1], [x, y-1], [x+1, y-1], [x-1, y], [x+1, y], [x-1, y+1], [x, y+1], [x+1, y+1]].select {| (x, y) | x >=0 && y >=0 && x < rows && y < columns}
    around_coordinates.reduce(0) {|accu, (a, b)| accu += cells[a][b]}
  end

  def draw_row(m)
    puts (0..columns-1).map {|n| cells[m][n] == 1 ? "*" : " "}.reduce(&:+)
  end

  def draw_board
    (0..rows-1).each  {|r| draw_row(r) }
  end
end


Game.new.start
