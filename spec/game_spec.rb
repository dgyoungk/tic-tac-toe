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
    before do
      # setting the replay value to prevent infinite loop
      new_game.instance_variable_set(:@replay, false)
    end

    context 'whether the replay attribute is true or not' do
      before do
        allow(new_game).to receive(:create_players)
        allow(new_game).to receive(:run_match)
        allow(new_game).to receive(:game_end)
        allow(new_game).to receive(:game_header)
        allow(new_game).to receive(:explain_game)
      end

      it 'displays the welcome msg' do
        expect(new_game).to receive(:game_header)
        new_game.game_setup
      end

      it 'creates 2 players' do
        expect(new_game).to receive(:create_players).twice
        new_game.game_setup
      end
      it 'explains how to play the game' do
        expect(new_game).to receive(:explain_game)
        new_game.game_setup
      end

      context 'when replay is false' do
        it 'does not trigger #set_board of Board' do
          expect(new_game.board).not_to receive(:set_board)
          new_game.game_setup
        end
        it 'does not trigger #run_match' do
          expect(new_game).not_to receive(:run_match)
          new_game.game_setup
        end
        it 'does not trigger #game_end' do
          expect(new_game).not_to receive(:game_end)
          new_game.game_setup
        end
      end
    end
  end

  # loop script: it will stop when both players are created
  describe '#create_players' do
    subject(:players) { described_class.new }

    context 'when method executes' do
      let(:dummy_player) { double('dummy_player', name: 'D') }

      before do
        allow(players).to receive(:player_info)
      end

      it 'triggers #player_info' do
        expect(players).to receive(:player_info)
        players.create_players
      end

      it 'triggers #assign_player' do
        allow(players).to receive(:gets).and_return(dummy_player.name)
        expect(players).to receive(:assign_player).with(dummy_player.name)
        players.create_players
      end
    end

    context 'when both players are already created' do
      before do
        players.instance_variable_set(:@p1, Player.new("D"))
        players.instance_variable_set(:@p2, Player.new("T"))
      end
      it '#assign_player does not change anything' do
        fiddlesticks = "F"
        allow(players).to receive(:gets).and_return(fiddlesticks)
        expect { players.assign_player(fiddlesticks) }.not_to change { players.p2 }
      end
    end
  end

  describe '#assign_player' do
    subject(:new_player) { described_class.new }
    let(:ziggs) { double('ziggs', name: 'Z') }

    context 'when neither players are set' do
      it 'assigns a Player object to p1' do
        new_player.assign_player(ziggs.name)
        expect(new_player.p1.name).to eq(ziggs.name)
      end
    end

    context 'when a player is already set' do
      let(:heimer) { double('heimer', name: 'H') }
      before do
        new_player.instance_variable_set(:@p1, Player.new(ziggs.name))
      end
      it 'assigns a Player object to p2' do
        new_player.assign_player(heimer.name)
        expect(new_player.p2.name).to eq(heimer.name)
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
      it 'triggers #alert_turn' do
        expect(game_match).to receive(:alert_turn)
        game_match.run_match
      end
      it 'triggers #play' do
        expect(game_match).to receive(:play)
        game_match.run_match
      end
      it 'triggers #display_board(board)' do
        allow(game_match).to receive(:play)
        expect(game_match).to receive(:display_board).with(game_match.board)
        game_match.run_match
      end
      it 'triggers #prompt_replay' do
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
      it 'alerts turn for player 2' do
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
      it 'alerts turn for player 1' do
        turn_msg = %(\nIt's #{player1.name}'s turn\n)
        expect { game_turn.alert_turn(game_turn.p1) }.to output(turn_msg).to_stdout
      end
    end
  end

  describe '#play' do
    subject(:gameplay) { described_class.new }

    context 'when a game is over' do
      before do
        gameplay.instance_variable_set(:@over, true)
      end
      it 'does not trigger #display_board' do
        expect(gameplay).not_to receive(:display_board).with(gameplay.board)
      end
      it 'does not trigger #place_marker' do
        expect(gameplay).not_to receive(:place_marker).with(gameplay.p1)
      end
      it 'does not trigger #alert_turn' do
        expect(gameplay).not_to receive(:alert_turn).with(gameplay.p1)
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

  describe '#place_marker' do
    subject(:marker) { described_class.new }
    let(:dummy_pos) { double('position', value: 9) }
    context 'when method executes' do
      before do
        marker.instance_variable_set(:@position, dummy_pos.value)
        marker.instance_variable_set(:@p1, Player.new("D"))
        allow(marker.board).to receive(:update_board).with(marker.p1, dummy_pos.value - 1)
        allow(marker).to receive(:game_over?)
        allow(marker).to receive(:get_position)
      end
      it 'triggers #get_position' do
        expect(marker).to receive(:get_position)
        marker.place_marker(marker.p1)
      end
      it 'triggers #update_board on the Board object' do
        expect(marker.board).to receive(:update_board).with(marker.p1, dummy_pos.value - 1)
        marker.place_marker(marker.p1)
      end
      it 'pushes the position value into the occupied array' do
        expect(marker.occupied).to receive(:push).with(dummy_pos.value - 1)
        marker.place_marker(marker.p1)
      end
      it 'triggers #game_over?' do
        expect(marker).to receive(:game_over?)
        marker.place_marker(marker.p1)
      end
    end
  end

  describe '#get_position' do
    subject(:to_verify) { described_class.new }
    let(:valid_choice) { double("valid_choice", value: 8) }
    let(:invalid_choice) { double("invalid choice", value: 12) }

    before do
      allow(to_verify).to receive(:choice_msg)
      allow(to_verify).to receive(:invalid_choice_msg)
    end

    context 'when input is valid' do
      before do
        allow(to_verify).to receive(:gets).and_return(valid_choice.value)
      end
      it 'sets the @position value' do
        expect { to_verify.get_position }.to change { to_verify.position }.to(valid_choice.value)
      end
      it '#position_verified? returns true' do
        expect(to_verify).to receive(:position_verified?).with(valid_choice.value).and_return(true)
        to_verify.position_verified?(valid_choice.value)
      end
    end

    context 'when input is invalid' do
      before do
        allow(to_verify).to receive(:gets).and_return(invalid_choice.value, valid_choice.value)
      end
      it "#invalid_choice_msg should trigger once" do
        expect(to_verify).to receive(:invalid_choice_msg).once
        to_verify.get_position
      end
    end

    context 'when input is invalid 3 times' do
      before do
        foo = 'bar'
        bar = 'foo'
        allow(to_verify).to receive(:gets).and_return(invalid_choice.value, foo, bar, valid_choice.value)
      end
      it '#invalid_choice_msg should trigger 3 times' do
        3.times { expect(to_verify).to receive(:invalid_choice_msg) }
        to_verify.get_position
      end
    end
  end

  describe '#game_over?' do
    subject(:finished) { described_class.new }

    context 'when one player has a winning combo' do
      before do
        finished.instance_variable_set(:@p1, Player.new("D", [0, 1, 2]))
        finished.instance_variable_set(:@p2, Player.new("T", [3, 7, 9]))
        allow(finished).to receive(:announce_winner).with(finished.p1)
      end
      it '#check_win_con returns true' do
        result = finished.check_win_con(finished.p1)
        expect(result).to be true
      end
      it 'should set over attribute to true' do
        expect { finished.game_over? }.to change { finished.over }.to true
      end
      it 'should trigger #announce_winner' do
        expect(finished).to receive(:announce_winner).with(finished.p1)
        finished.game_over?
      end
    end

    context 'when neither player has a winning combo' do
      let(:results) { [] }
      before do
        finished.instance_variable_set(:@p1, Player.new("D", [2, 6, 8]))
        finished.instance_variable_set(:@p2, Player.new("T", [3, 7, 9]))
      end
      it '#check_win_con returns false twice' do
        results << finished.check_win_con(finished.p1)
        results << finished.check_win_con(finished.p2)
        expect(results).to all(be false)
      end

      context 'and the board has no space left' do
        before do
          finished.instance_variable_set(:@occupied, (0..8).to_a)
          allow(finished).to receive(:declare_draw)
        end
        it 'triggers #declare_draw' do
          expect(finished).to receive(:declare_draw)
          finished.game_over?
        end
        it 'changes the over attribute to true' do
          expect { finished.game_over? }.to change { finished.over }.to true
        end
      end
    end
  end

  describe '#prompt_replay' do
    subject(:prompt) { described_class.new }
    before do
      allow(prompt).to receive(:replay_msg)
    end

    context "when user's choice is 'n'" do
      let(:no_replay) { double('no_replay', value: 'n') }
      before do
        allow(prompt).to receive(:get_player_choice).and_return(no_replay.value)
      end
      it 'replay should be set to false' do
        expect { prompt.prompt_replay }.to change { prompt.replay }.to false
      end
    end

    context "when user's choice is 'y'" do
      let(:yes_replay) { double('yes_replay', value: 'y') }
      before do
        allow(prompt).to receive(:get_player_choice).and_return(yes_replay.value)
      end
      it 'replay should not change value' do
        expect { prompt.prompt_replay }.not_to change { prompt.replay }
      end
    end
  end

  describe '#get_player_choice' do
    subject(:replay_choice) { described_class.new }
    let(:valid_choice) { double('valid_choice', value: 'y') }
    let(:invalid_choice) { double('invalid_choice', value: 'nono') }

    before do
      allow(replay_choice).to receive(:replay_msg)
    end

    context 'when input is valid' do
      before do
        allow(replay_choice).to receive(:gets).and_return(valid_choice.value)
      end
      it 'returns the input' do
        expect(replay_choice).to receive(:get_player_choice).and_return(valid_choice.value)
        replay_choice.get_player_choice
      end
      it '#choice_verified? should return true' do
        expect(replay_choice).to receive(:choice_verified?).with(valid_choice.value).and_return(true)
        replay_choice.get_player_choice
      end
    end

    context 'when input is invalid once' do
      before do
        allow(replay_choice).to receive(:gets).and_return(invalid_choice.value, valid_choice.value)
      end
      it 'should display invalid_choice_msg once' do
        expect(replay_choice).to receive(:invalid_choice_msg).once
        replay_choice.get_player_choice
      end
    end

    context 'when input value is invalid 4 times' do
      before do
        foo = 'bar'
        bar = 'foo'
        gaga = 'gaga'
        allow(replay_choice).to receive(:gets).and_return(invalid_choice.value, foo, bar, gaga, valid_choice.value)
      end
      it 'should display invalid_choice_msg 4 times' do
        4.times { expect(replay_choice).to receive(:invalid_choice_msg) }
        replay_choice.get_player_choice
      end
    end
  end

  describe '#game_end' do
    subject(:game_over) { described_class.new }

    context 'when replay is true' do
      before do
        allow(game_over).to receive(:game_footer)
        game_over.instance_variable_set(:@replay, true)
      end
      it 'triggers #reset_game' do
        expect(game_over).to receive(:reset_game)
        game_over.game_end
      end
    end

    context 'when replay is false' do
      before do
        allow(game_over).to receive(:reset_game)
        game_over.instance_variable_set(:@replay, false)
      end
      it 'triggers #game_footer' do
        expect(game_over).to receive(:game_footer)
        game_over.game_end
      end
    end
  end
end
