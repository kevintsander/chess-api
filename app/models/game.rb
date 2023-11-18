class Game < ApplicationRecord
  serialize :game_state

  def as_json(options = {})
    opts = {
      only: %i[game_id created_at updated_at],
      methods: %i[units allowed_actions]
    }

    super(options.merge(opts))
  end

  def units
    game_state.board.units.map do |unit|
      return { player: unit.player.color, symbol: unit.symbol, location: unit.location }
    end
  end

  def allowed_actions
    consolidated = []
    game_state.allowed_actions&.each do |_location, actions|
      actions.each do |action|
        ## TODO comparisons might not work here if actions dont have equality overrides
        ## TODO player.name is probaly not best comparison
        is_current_player_action = action.moves.any? { |m| m.unit.player.name == game_state.current_player.name }
        next unless !consolidated.include?(action) && is_current_player_action

        moves = action.moves.map { |move| { from_location: move.from_location, to_location: move.location } }
        consolidated.push({ moves:,
                            capture_unit: action.capture_unit })
      end
    end
    consolidated
  end
end
