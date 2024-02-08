class Player
  attr_accessor :name, :marker, :player_count, :marked

  @@player_count = 0

  def initialize(name)
    self.name = name
    @@player_count += 1
    designate_marker()
    self.marked = []
  end

  def designate_marker
    if total_players() == 1
      self.marker = 'O'
    else
      self.marker = 'X'
    end
  end

  def update_positions(position)
    self.marked << position
  end

  private

  def total_players
    @@player_count
  end
end
