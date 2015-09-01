class Board
  attr_accessor :cells, :live_cells

  def initialize
    @cells = []
    (1..10).each do |row|
      row = []
      (1..10).each do |marker|
        row << Cell.new(marker)
      end
      @cells << row
    end
  end

  def starting_position
    @live_cells = []

    (0..99).to_a.sample.times do
      x = (0..9).to_a.sample
      y = (0..9).to_a.sample
      @live_cells << [x, y]
    end

    @live_cells.each do |cell|
      cells[cell[0]][cell[1]].marker = "O"
    end
  end

  def print_board
    system "clear"
    cells.each do |row|
      puts "#{row[0].marker} #{row[1].marker} #{row[2].marker} #{row[3].marker} #{row[4].marker} #{row[5].marker} #{row[6].marker} #{row[7].marker} #{row[8].marker} #{row[9].marker}"
    end
  end

  def process_a_round
    to_die = []
    to_create = []
    cells.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        if cell.marker == "O"
          count = number_of_live_neighbors(x, y)
          if count > 3 || count < 2
            to_die << cell
          end
        end

        if cell.marker == "-"
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
      cell.marker = "-"
    end

    to_create.each do |cell|
      cell.marker = "O"
    end
  end

  def number_of_live_neighbors(x, y)
    count = 0
    if x != 9
      if cells[x + 1][y].marker == "O"
        count += 1
      end
    end

    if y != 9
      if cells[x][y + 1].marker == "O"
        count += 1
      end
    end

    if x != 0
      if cells[x - 1][y].marker == "O"
        count += 1
      end
    end

    if y != 0
      if cells[x][y - 1].marker == "O"
        count += 1
      end
    end

    if x != 9 && y != 9
      if cells[x + 1][y + 1].marker == "O"
        count += 1
      end
    end

    if x != 0 && y != 0
      if cells[x - 1][y - 1].marker == "O"
        count += 1
      end
    end

    if x != 9 && y != 0
      if cells[x + 1][y - 1].marker == "O"
        count += 1
      end
    end

    if x != 0 && y != 9
      if cells[x - 1][y + 1].marker == "O"
        count += 1
      end
    end

    count
  end
end

class Cell
  attr_accessor :marker

  def initialize(marker)
    @marker = "-"
  end
end

class Game
  def start
    welcome_message
    @board = Board.new
    @board.starting_position
    loop do
      @board.print_board
      @board.process_a_round
      sleep(1)
      break if all_dead
    end
    @board.print_board
    goodbye_message
  end

  def welcome_message
    puts "Welcome to Conway's The Game of Life!"
  end

  def goodbye_message
    puts "Looks like all your cells died. Too bad!"
  end

  def all_dead
    living_cells = []
    @board.cells.each do |row|
      row.each do |cell|
        living_cells << cell if cell.marker == "O"
      end
    end
    true if living_cells == []
  end
end

Game.new.start
