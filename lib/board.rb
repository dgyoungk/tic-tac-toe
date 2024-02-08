class Board
  attr_accessor :game_area

  def initialize
    self.game_area = Array.new(8)
  end

  def update_board(player, position)
    self.game_area[position - 1] = player.marker
    player.update_positions(position - 1)
  end

  def set_board
    for i in 0..game_area.length
      self.game_area[i] = ' '
    end
  end
end
