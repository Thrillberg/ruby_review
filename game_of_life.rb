class Board
  attr_accessor :cells, :live_cells, :rows, :columns

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @cells = []
    (1..rows).each do |row|
      row = []
      (1..columns).each do |_|
        row << Cell.new
      end
      @cells << row
    end
  end

  def starting_position
    @live_cells = []

    rand((rows * columns) - 1).times do
      x, y = rand(rows - 1), rand(columns - 1)
      @live_cells << [x, y]
      cells[x][y].set_alive!
    end
  end

  def print
    system "clear"
    puts "~" * columns * 2
    cells.each do |row|
      line = ""
      row.each do |cell|
        line << cell.marker + " "
      end
      puts line
    end
    puts "~" * columns * 2
  end

  def process_a_round
    to_die = []
    to_create = []
    cells.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        if cell.alive?
          count = number_of_live_neighbors(x, y)
          if count > 3 || count < 2
            to_die << cell
          end
        end

        if !cell.alive?
          count = number_of_live_neighbors(x, y)
          if count == 3
            to_create << cell
          end
        end
      end
    end
    cell_cycle(to_die, to_create)
  end

  def cell_cycle(to_die, to_create)
    to_die.each do |cell|
      cell.kill!
    end

    to_create.each do |cell|
      cell.set_alive!
    end
  end

  def number_of_live_neighbors(x, y)
    neighbor_coordinates = [[x-1, y-1], [x, y-1], [x+1, y-1], [x-1, y], [x+1, y], [x-1, y+1], [x, y+1], [x+1, y+1]].select {| (x, y) | x >=0 && y >=0 && x < rows && y < columns}
    neighbor_coordinates.reduce(0) {|accu, (a, b)| accu += cells[a][b].value}
  end

  def all_dead
    living_cells = []
    cells.each do |row|
      row.each do |cell|
        living_cells << cell if cell.value == 1
      end
    end
    living_cells == []
  end

end

class Cell
  attr_accessor :marker, :y, :x, :value

  def initialize
    @marker = " "
    @value = 0
  end

  def alive?
    @value == 1
  end

  def set_alive!
    @value = 1
    @marker = "O"
  end

  def kill!
    @value = 0
    @marker = " "
  end
end

class Game
  def start
    @board = Board.new(100,100)
    @board.starting_position
    loop do
      @board.print
      @board.process_a_round
      sleep(0.1)
      break if @board.all_dead
    end
    @board.print
    goodbye_message
  end

  def goodbye_message
    puts "Looks like all your cells died. Too bad!"
  end
end

Game.new.start
