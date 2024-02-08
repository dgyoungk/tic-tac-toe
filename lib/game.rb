require './Displayable.rb'
require './Player.rb'

class Game
  include Displayable

  WIN_CONS = [(0..2).to_a, (3..5).to_a, (6..8).to_a, [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

  attr_accessor :board, :p1, :p2, :occupied, :turns, :over, :stop

  def initialize(board)
    self.board = board
    self.occupied = []
    self.turns = 1
    self.stop = false
    self.over = false
    game_setup()
  end

  def show
    if self.turns < 2
      puts
      explain_game()
      alert_turn(self.p1)
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

  def start_game
    until self.stop
      run_match()
    end
  end

  def run_match
    until self.over
      show()
      print %(Choice: )
      choice = gets.chomp.to_i
      play(choice)
    end
    show()
    prompt_replay()
    play_again()
  end

  def play_again
    replay = gets.chomp
    replay.downcase!
    until replay == 'y' || replay == 'n'
      puts %(Invalid option, please try again)
      prompt_replay()
      replay = gets.chomp.downcase!
    end
    if replay == 'n'
      self.stop = true
      game_footer()
    else
      reset_game()
    end
  end

  # checks whether a board position is already occupied before placing marker
  def place_marker(player, position)
    until position > 0 && position < 10
      puts "Invalid choice, try again \n\n"
      print %(Choice: )
      position = gets.chomp.to_i
    end

    until self.occupied.empty? || !self.occupied.include?(position - 1)
      puts %(That position it taken, try again)
      print %(Choice: )
      position = gets.chomp.to_i
    end

    self.board.update_board(player, position)
    update_turns()
    self.occupied << position - 1

    game_over?()
  end

  def play(choice)
    if self.turns.even?
      place_marker(self.p2, choice)
      alert_turn(self.p1) unless self.over
    elsif self.turns.odd?
      place_marker(self.p1, choice)
      alert_turn(self.p2) unless self.over
    end
  end

  # checks whether a player has won or all slots are filled up
  def game_over?
    p1_win = WIN_CONS.any? { |combo| combo.intersection(self.p1.marked) == combo }
    p2_win = WIN_CONS.any? { |combo| combo.intersection(self.p2.marked) == combo }

    if p1_win
      self.over = true
      announce_winner(self.p1)
    elsif p2_win
      self.over = true
      announce_winner(self.p2)
    elsif self.occupied.length == 9
      declare_draw()
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
    self.board.reset_board
  end

  private

  def update_turns
    @turns += 1
  end

  attr_reader :turns
end
