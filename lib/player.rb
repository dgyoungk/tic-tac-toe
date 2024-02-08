class Player
  attr_accessor :name, :marker, :marked

  @@player_count = 0

  def initialize(name)
    self.name = name
    @@player_count += 1
    self.marked = []
    designate_marker()
  end

  def designate_marker
    total_players == 1 ? self.marker = 'O' : self.marker = 'X'
  end

  def update_positions(position)
    self.marked << position
  end

  private

  def total_players
    @@player_count
  end
end
