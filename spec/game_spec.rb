# Bulk of the testing will be done here
# Types to test:
# Command method => the change in the observable state
# Query method => the return value
# Method with outgoing commands => a message is sent
# Looping script method => the behavior of the method (like does it stop when a condition is met)

require './lib/game.rb'
require './lib/board.rb'
require './lib/player.rb'
require './lib/displayable.rb'

describe Game do
  describe '#game_setup' do
    subject(:new_game) { described_class.new }
    context 'when #game_setup is called' do
      before do
        allow(new_game).to receive(:game_header)
        allow(new_game).to receive(:explain_game)
        allow(new_game).to receive(:create_players).twice
        allow(new_game.board).to receive(:set_board)
        allow(new_game).to receive(:run_match)
        allow(new_game).to receive(:game_end)
      end

      xit 'sends #game_header' do
        expect(new_game).to receive(:game_header)
        new_game.game_setup
      end
      # why does the loop execute this method 3 times?
      xit 'sends #create_players to self' do
        expect(new_game).to receive(:create_players).twice
        new_game.game_setup
      end
      xit 'sends #explain_game to self' do
        expect(new_game).to receive(:explain_game)
        new_game.game_setup
      end
      xit 'sends #set_board to game_board' do
        expect(new_game.board).to receive(:set_board)
        new_game.game_setup
      end
      xit 'sends #run_match to self' do
        expect(new_game).to receive(:run_match)
        new_game.game_setup
      end
      xit 'sends run_match to self' do
        expect(new_game).to receive(:run_match)
        new_game.game_setup
      end
    end
  end

  # loop script: it will stop when both players are created
  describe '#create_players' do
    subject(:players) { described_class.new }
    context 'when method executes' do
      let(:dummy_player) { Player.new("D") }
      before do
        allow(players).to receive(:player_info)
        allow(players).to receive(:get_player_id)
      end

      xit 'triggers #player_info' do
        expect(players).to receive(:player_info)
        players.create_players
      end

      xit 'triggers #get_player_id' do
        expect(players).to receive(:get_player_id)
        players.create_players
      end

      xit 'triggers #assign_player' do
        allow(players).to receive(:get_player_id).and_return(dummy_player.name)
        expect(players).to receive(:assign_player).with(dummy_player.name)
        players.create_players
      end
    end
  end

  describe '#assign_player' do
    subject(:new_player) { described_class.new }
    let(:player) { Player.new("D") }
    context 'when neither players are set' do
      xit 'assigns a Player object to p1' do
        new_player.assign_player("D")
        expect(new_player.p1.name).to eql(player.name)
      end
    end
    context 'when a player is already set' do
      let(:player_2) { Player.new("T") }
      before do
        new_player.instance_variable_set(:@p1, player)
      end
      xit 'assigns a Player object to p2' do
        new_player.assign_player("T")
        expect(new_player.p2.name).to eql(player_2.name)
      end
    end
  end

  describe '#explain_game' do
    subject(:game_msgs) { described_class.new }
    context 'when method executes' do
      xit 'outputs the appropriate message to console' do
        msg1 = %(\nEnter a number between 1-9 to choose your marker location:)
        msg2 = %(1-top-left corner, 9-bottom-right corner)
        expect(game_msgs).to receive(:puts).and_return(msg1, msg2)
        game_msgs.explain_game
      end
    end
  end

  describe '#run_match' do
    subject(:game_match) { described_class.new }
    context 'when method executes' do
      before do
        allow(game_match).to receive(:alert_turn)
        allow(game_match).to receive(:play)
        allow(game_match).to receive(:display_board).with (game_match.board)
        allow(game_match).to receive(:prompt_replay)
      end
      xit 'triggers #alert_turn' do
        # allow(game_match).to receive(:play)
        expect(game_match).to receive(:alert_turn)
        game_match.run_match
      end
      xit 'triggers #play' do
        expect(game_match).to receive(:play)
        game_match.run_match
      end
      xit 'triggers #display_board(board)' do
        allow(game_match).to receive(:play)
        expect(game_match).to receive(:display_board).with(game_match.board)
        game_match.run_match
      end
      xit 'triggers #prompt_replay' do
        expect(game_match).to receive(:prompt_replay)
        game_match.run_match
      end
    end
  end

  describe '#alert_turn' do
    subject(:game_turn) { described_class.new }
    context 'when turns is even' do
      let(:player2) { Player.new("T") }
      before do
        game_turn.instance_variable_set(:@turn, 2)
        game_turn.instance_variable_set(:@p2, player2)
      end
      xit 'alerts turn for player 2' do
        turn_msg = %(\nIt's #{player2.name}'s turn\n)
        expect { game_turn.alert_turn(game_turn.p2) }.to output(turn_msg).to_stdout
      end
    end
    context 'when turns is odd' do
      let(:player1) { Player.new("D") }
      before do
        game_turn.instance_variable_set(:@turn, 3)
        game_turn.instance_variable_set(:@p1, player1)
      end
      xit 'alerts turn for player 1' do
        turn_msg = %(\nIt's #{player1.name}'s turn\n)
        expect { game_turn.alert_turn(game_turn.p1) }.to output(turn_msg).to_stdout
      end
    end
  end

  # looping and command message method
  # things to test: method triggers and loop stop conditions
  # TODO: test the gameplay methods
  describe '#play' do
    subject(:gameplay) { described_class.new }
    context 'when a game is over' do
      before do
        gameplay.instance_variable_set(:@over, true)
        allow(gameplay).to receive(:place_marker).with(gameplay.p1)
      end
      it 'does not trigger board display' do
        expect(gameplay).not_to receive(:display_board).with(gameplay.board)
      end
    end
    context 'when game is not over and turns is 6' do
      before do
        allow(gameplay).to receive(:place_marker).with(gameplay.p1)
        allow(gameplay).to receive(:alert_turn).with(gameplay.p1)
        allow(gameplay).to receive(:display_board).with(gameplay.board)
      end
      it 'triggers board display at least 3 times' do
        3.times { expect(gameplay).to receive(:display_board).with(gameplay.board) }
        gameplay.play
      end
      it 'triggers #place_marker at least 3 times' do
        3.times { expect(gameplay).to receive(:place_marker).with(gameplay.p1) }
        gameplay.play
      end
      it 'triggers #alert_turn at least 3 times' do
        3.times { expect(gameplay).to receive(:alert_turn).with(gameplay.p1) }
        gameplay.play
      end
    end
  end

  describe '#game_end' do
    subject(:game_over) { described_class.new }
    context 'when replay is true' do
      before do
        allow(game_over).to receive(:game_footer)
        game_over.replay = true
      end
      xit 'triggers #reset_game' do
        expect(game_over).to receive(:reset_game)
        game_over.game_end
      end
    end

    context 'when replay is false' do
      before do
        allow(game_over).to receive(:reset_game)
        game_over.replay = false
      end
      xit 'triggers #game_footer' do
        expect(game_over).to receive(:game_footer)
        game_over.game_end
      end
    end
  end
end
