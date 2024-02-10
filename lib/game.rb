require './lib/displayable.rb'
require './lib/player.rb'

class Game
  include Displayable

  WIN_CONS = [(0..2).to_a, (3..5).to_a, (6..8).to_a, [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

  attr_accessor :board, :p1, :p2, :occupied, :turns, :over, :replay, :position

  def initialize(board = Board.new, occupied = [], turns = 1, replay = true, over = false, p1 = nil, p2 = nil)
    self.board = board
    self.occupied = occupied
    self.turns = turns
    self.replay = replay
    self.over = over
    self.p1 = p1
    self.p2 = p2
    self.position = 0
  end

  def game_setup
    game_header()
    2.times { create_players }
    explain_game
    while replay
      board.set_board
      run_match
      game_end
    end
  end

  def create_players
    player_info
    new_player = get_player_id
    # new_player = "D"
    assign_player(new_player)
  end

  def get_player_id
    return gets.chomp
  end

  def assign_player(player_id)
    p1.nil? ? self.p1 = Player.new(player_id) : self.p2 = Player.new(player_id)
  end

  def run_match
    turns.even? ? alert_turn(p2) : alert_turn(p1)
    play
    display_board(board)
    prompt_replay
  end

  def play
    until self.over || turns > 9
      display_board(board)
      turns.even? ? place_marker(p2) : place_marker(p1)
      unless over
        turns.even? ? alert_turn(p1) : alert_turn(p2)
      end
      update_turns()
    end
  end

  # since the position is going to be an index in the board array, subtract 1 from position
  # to use it as the array index
  def place_marker(player)
    get_position
    board.update_board(player, position - 1)
    self.occupied.push(position - 1)
    game_over?()
  end

  def get_position
    choice_msg
    posit_choice = gets.to_i
    until position_verified?(posit_choice)
      invalid_choice_msg
      choice_msg
      posit_choice = gets.to_i
    end
    self.position = posit_choice
  end

  def position_verified?(user_position)
    return user_position > 0 && user_position < 10 && !occupied.include?(user_position - 1)
  end

  def get_player_choice
    choice = gets.chomp.downcase
    until choice_verified?(choice)
      invalid_choice_msg
      replay_msg
      choice = gets.chomp.downcase
    end
    choice
  end

  def choice_verified?(decision)
    return decision == 'y' || decision == 'n'
  end

  def prompt_replay
    replay_msg
    decision = get_player_choice
    self.replay = false if decision == 'n'
  end

  def game_end
    replay ? reset_game : game_footer
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
    self.replay = true
    self.over = false
    self.turns = 1
    self.board.set_board
  end

  private

  def update_turns
    @turns += 1
  end
end
