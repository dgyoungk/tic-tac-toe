module Displayable

  def display_board(area)
    puts %( #{area[0]} | #{area[1]} | #{area[2]} \n) +
         %(---|---|---\n) +
         %( #{area[3]} | #{area[4]} | #{area[5]} \n) +
         %(---|---|---\n) +
         %( #{area[6]} | #{area[7]} | #{area[8]} \n)
  end

  def announce_winner(player)
    puts
    puts %(#{player.name} wins!)
  end

  def declare_draw()
    puts %(It's a draw, evenly matched!)
  end

  def alert_turn(player)
    puts
    puts %(It's #{player.name}'s turn)
  end

  def explain_game()
    puts %(Enter a number between 1-9 to choose your marker location:)
    puts %(1-top-left corner, 9-bottom-right corner)
  end

  def player_info(count)
    puts %(Player #{count} name (no numbers or special characters): )
  end

  def game_header
    puts %(Let's play some tic tac toe!)
    puts
  end

  def prompt_replay
    puts %(\nDo you wanna play again? (Y/N))
  end

  def game_footer
    puts %(\nThanks for playing!)
  end
end
