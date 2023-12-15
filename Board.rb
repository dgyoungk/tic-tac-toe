class Board
  attr_accessor :board

  def initialize
    self.board = Array.new(8)
    for i in 0..board.length
      self.board[i] = " "
    end
  end

  def update_board(player, position)
    self.board[position - 1] = player.marker
    player.update_positions(position - 1)
  end
end
