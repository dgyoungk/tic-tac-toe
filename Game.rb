require './Displayable.rb'
require './Player.rb'

class Game
  include Displayable

  WIN_CONS = [(0..2).to_a, (3..5).to_a, (6..8).to_a, [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

  attr_accessor :board, :p1, :p2, :occupied

  def initialize(board)
    self.board = board
    self.occupied = []
    @turns = 1
    game_setup()
  end

  def show
    if self.turns < 2
      explain_game()
    end
    display_board(self.board.game_area)
  end

  def game_setup
    game_header()
    count = 1
    until self.p1 && self.p2
      player_info(count)
      game_tag = gets.chomp
      game_player = Player.new(game_tag)
      self.p1 ? self.p2 = game_player : self.p1 = game_player
      puts
      count += 1
    end
  end

  # checks whether a board position is already occupied before placing marker
  def place_marker(player, position)
    if position > 0 && position < 10
      if self.occupied.empty? || !self.occupied.include?(position - 1)
        self.board.update_board(player, position)
        update_turns()
        self.occupied << position - 1
      else
        puts "That position is taken, try again \n\n"
      end
    else
      puts "Invalid input, try again \n\n"
    end
  end

  # checks whether a player has won or all slots are filled up
  def game_over?
    p1_win = WIN_CONS.any? { |combo| combo.intersection(self.p1.marked) == combo }
    p2_win = WIN_CONS.any? { |combo| combo.intersection(self.p2.marked) == combo }

    if p1_win
      announce_winner(self.p1)
      p1_win
    elsif p2_win
      announce_winner(self.p2)
      p2_win
    elsif self.occupied.length == 9
      declare_draw()
      true
    else
      false
    end
  end

  def play(choice)
    if self.turns.even?
      place_marker(self.p2, choice)
      alert_turn(self.p1)
    elsif self.turns.odd?
      place_marker(self.p1, choice)
      alert_turn(self.p2)
    end
  end

  private

  def update_turns
    @turns += 1
  end

  attr_reader :turns
end
