require './Displayable.rb'

class Game
  include Displayable

  # I need a flag to indicate whether a game is over, whether win draw or lose
  # win condition for either players: marker is in 3 consecutive slots (verti, horiz, diag)
  # so either 0-2, 3-5, 6-8 (horiz), 0 3 6, 1 4 7, 2 5 8 (verti), or 0 4 8, 2 4 6 (diag)

  WIN_CONS = [(0..2).to_a, (3..5).to_a, (6..8).to_a, [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]


  attr_accessor :board, :p1, :p2, :occupied

  def initialize(board, p1, p2)
    self.board = board
    self.p1 = p1
    self.p2 = p2
    self.occupied = []
  end

  # checks whether a board position is already occupied before placing marker
  def place_marker(player, position)
    if position > 0 && position < 10
      if self.occupied.empty? || !self.occupied.include?(position - 1)
        self.board.update_board(player, position)
        self.occupied << position - 1
      else
        puts "That position is taken, try again \n\n"
      end
    else
      puts "Invalid input, try again \n\n"
    end
  end

  # checks whether a player has won or all slots are filled up
  def game_over?(p1, p2)
    if self.occupied.length == 8
      true
    else
      return WIN_CONS.any? { |combo| combo.intersection(p1.marked) == combo }
    end
    false
  end
end
