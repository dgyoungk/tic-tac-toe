require './Displayable.rb'

class Game
  include Displayable

  WIN_CONS = [(0..2).to_a, (3..5).to_a, (6..8).to_a, [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

  attr_accessor :board, :p1, :p2, :occupied

  def initialize(board, p1, p2)
    self.board = board
    self.p1 = p1
    self.p2 = p2
    self.occupied = []
    @turns = 0
  end

  def show
    display_board(self.board.game_area)
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
  def game_over?(p1, p2)
    p1_win = WIN_CONS.any? { |combo| combo.intersection(p1.marked) == combo }
    p2_win = WIN_CONS.any? { |combo| combo.intersection(p2.marked) == combo }

    if p1_win
      announce_winner(p1)
      p1_win
    elsif p2_win
      announce_winner(p2)
      p2_win
    elsif self.occupied.length == 8
      declare_draw()
      true
    else
      false
    end
  end

  private

  def update_turns
    @turns += 1
  end

  attr_reader :turns

  def determine_turn
    if self.turns.even?
      alert_turn(p1)
    elsif self.turns.odd?
      alert_turn(p2)
    end
  end
end
