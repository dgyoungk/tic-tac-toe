class Board
  attr_accessor :game_area

  def initialize(game_area = Array.new(8))
    self.game_area = game_area
  end

  def update_board(player, position)
    self.game_area.insert(position, player.marker)
    player.update_positions(position)
  end

  def set_board
    game_area.length.times { |n| game_area[n] = ' ' }
  end
end
