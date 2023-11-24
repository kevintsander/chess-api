class Game < ApplicationRecord
  serialize :game_state

  ACTION_MAP = { 'NormalMoveCommand' => 'Move',
                 'AttackMoveCommand' => 'Attack',
                 'KingsideCastleMoveCommand' => 'KingsideCastle',
                 'QueensideCastleMoveCommand' => 'QueensideCastle',
                 'EnPassantMoveCommand' => 'EnPassant' }.freeze

  def simplified
    {
      id:,
      created_at:,
      updated_at:,
      turn: game_state.turn,
      current_player: game_state.current_player.color,
      units:,
      allowed_actions:
    }
  end

  def units
    game_state.board.units.map do |unit|
      { player: unit.player.color, type: unit.class.name.demodulize, symbol: unit.symbol,
        location: unit.location }
    end
  end

  def allowed_actions
    consolidated_actions = []

    game_state.allowed_actions_cache&.each do |_location, actions|
      actions.each do |action|
        ## TODO player.name is probaly not best comparison
        is_current_player_action = action.moves.any? { |m| m.unit.player.name == game_state.current_player.name }
        next unless !consolidated_actions.include?(action) && is_current_player_action

        moves = action.moves.map { |move| { from_location: move.from_location, to_location: move.location } }
        action_type = ACTION_MAP[action.class.name.demodulize]
        consolidated_actions.push({ type: action_type,
                                    moves:,
                                    capture_unit: action.capture_unit&.location })
      end
    end
    consolidated_actions
  end
end
