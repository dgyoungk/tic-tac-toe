require './lib/displayable.rb'
require './lib/player.rb'

class Game
  include Displayable

  WIN_CONS = [(0..2).to_a, (3..5).to_a, (6..8).to_a, [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

  attr_accessor :board, :p1, :p2, :occupied, :turns, :over, :replay

  def initialize(board = Board.new, occupied = [], turns = 1, replay = true, over = false)
    self.board = board
    self.occupied = occupied
    self.turns = turns
    self.replay = replay
    self.over = over
    game_setup()
  end

  def game_setup
    game_header()
    until self.p1 && self.p2
      player_info
      create_player
    end
    explain_game
    board.set_board
    run_match
    game_end
  end

  def create_player
    p1.nil? ? self.p1 = Player.new(gets.chomp) : self.p2 = Player.new(gets.chomp)
  end

  def run_match
    turns.even? ? alert_turn(p2) : alert_turn(p1)
    until self.over || turns > 9
      display_board(board)
      play
    end
    display_board(board)
    prompt_replay
  end

  def play
    if turns.even?
      place_marker(self.p2)
      alert_turn(self.p1) unless self.over
    else
      place_marker(self.p1)
      alert_turn(self.p2) unless self.over
    end
  end

  def verify_position
    print %(Choice: )
    position = gets.chomp.to_i
    until (position > 0 && position < 10) && (self.occupied.empty? || !self.occupied.include?(position - 1))
      puts "Invalid choice, try again"
      print %(Choice: )
      position = gets.chomp.to_i
    end
    position
  end

  def verify_choice
    choice = gets.chomp.downcase
    until choice == 'y' || choice == 'n'
      puts %(Invalid option, please try again)
      replay_msg
      choice = gets.chomp.downcase
    end
    choice
  end

  def prompt_replay
    replay_msg
    decision = verify_choice
    self.replay = false if decision == 'n'
  end

  def game_end
    replay ? reset_game : game_footer
  end

  # checks whether a board position is already occupied before placing marker
  def place_marker(player)
    position = verify_position
    board.update_board(player, position)
    update_turns()
    self.occupied << position - 1
    game_over?()
  end

  def check_win_con(player)
    return WIN_CONS.any? { |combo| combo.intersection(player.marked) == combo }
  end

  # checks whether a player has won or all slots are filled up
  def game_over?
    p1_win = check_win_con(p1)
    p2_win = check_win_con(p2)
    if p1_win
      announce_winner(p1)
      self.over = true
    elsif p2_win
      announce_winner(p2)
      self.over = true
    elsif occupied.length == 9
      declare_draw
      self.over = true
    end
  end

  def reset_game
    self.p1.marked = []
    self.p2.marked = []
    self.occupied = []
    self.stop = false
    self.over = false
    self.turns = 1
    self.board.set_board
  end

  private

  def update_turns
    @turns += 1
  end

  attr_reader :turns
end
