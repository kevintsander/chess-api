class Game < ApplicationRecord
  serialize :game_state

  ACTION_MAP = { 'NormalMoveCommand' => 'Move',
                 'AttackMoveCommand' => 'Attack',
                 'KingsideCastleMoveCommand' => 'KingsideCastle',
                 'QueensideCastleMoveCommand' => 'QueensideCastle',
                 'EnPassantMoveCommand' => 'EnPassant',
                 'PromoteCommand' => 'Promote' }.freeze

  def simplified
    {
      id:,
      created_at:,
      updated_at:,
      turn: game_state.turn,
      current_player: game_state.current_player.color,
      units:,
      allowed_actions:,
      promote_location: game_state.promote_location,
      status: game_state.status
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
    game_state.allowed_actions&.each do |_location, actions|
      actions.each do |action|
        action_type = ACTION_MAP[action.class.name.demodulize]
        moves = action.moves.map { |move| { from_location: move.from_location, to_location: move.location } }
        consolidated_actions.push({ type: action_type,
                                    moves:,
                                    capture_unit: action.capture_unit&.location })
      end
    end
    consolidated_actions
  end
end
