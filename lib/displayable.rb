module Displayable

  def display_board(board)
    puts %( #{board.game_area[0]} | #{board.game_area[1]} | #{board.game_area[2]} \n) +
         %(---|---|---\n) +
         %( #{board.game_area[3]} | #{board.game_area[4]} | #{board.game_area[5]} \n) +
         %(---|---|---\n) +
         %( #{board.game_area[6]} | #{board.game_area[7]} | #{board.game_area[8]} \n)
  end

  def announce_winner(player)
    puts %(\n#{player.name} wins!)
  end

  def declare_draw()
    puts %(It's a draw, evenly matched!)
  end

  def alert_turn(player)
    puts %(\nIt's #{player.name}'s turn)
  end

  def explain_game()
    puts %(\nEnter a number between 1-9 to choose your marker location:)
    puts %(1-top-left corner, 9-bottom-right corner)
  end

  def player_info
    print %(Player name: )
  end

  def game_header
    puts %(Let's play some tic tac toe!)
  end

  def replay_msg
    print %(\nDo you wanna play again? (Y/N): )
  end

  def game_footer
    puts %(\nThanks for playing!)
  end
end
