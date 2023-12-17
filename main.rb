require './Game.rb'
require './Board.rb'
require './Displayable.rb'

tic = Board.new

tac = Game.new(tic)

tac.start_game
