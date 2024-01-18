class Game < ApplicationRecord
  belongs_to :player1_user, foreign_key: 'player1_user_id', class_name: 'User', optional: true
  belongs_to :player2_user, foreign_key: 'player2_user_id', class_name: 'User', optional: true

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
      current_color: game_state.current_color,
      player1: player1_user ? { id: player1_user.id, nickname: player1_user.nickname } : nil,
      player2: player2_user ? { id: player2_user.id, nickname: player2_user.nickname } : nil,
      units:,
      allowed_actions:,
      promote_location: game_state.promote_location,
      status: game_state.status
    }
  end

  def units
    game_state.board.units.map do |unit|
      { color: unit.color, type: unit.class.name.demodulize, symbol: unit.symbol,
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

  def current_player
    case game_state.current_color
    when :white
      player1_user
    when :black
      player2_user
    end
  end
end
