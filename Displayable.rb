module Displayable

  def display_board(area)
    puts %( #{area[0]} | #{area[1]} | #{area[2]} \n) +
         %(---|---|---\n) +
         %( #{area[3]} | #{area[4]} | #{area[5]} \n) +
         %(---|---|---\n) +
         %( #{area[6]} | #{area[7]} | #{area[8]} \n)
  end

  def announce_winner(player)
  end

  def declare_draw()
  end

  def alert_turn(player)
  end
end
