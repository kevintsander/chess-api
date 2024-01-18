class GamesController < ApplicationController
  def create
    game_state = ChessEngine::Game.new()
    game_state.start
    game = Game.create!(game_state:)

    ActionCable.server.broadcast("game_#{game.id}", game.simplified)
    render json: game.id
  end

  def update
    id = params[:id]
    game = Game.find(id)

    unless game.current_player == current_user
      render json: { error: "Logged in user is not current player" }, status: :unauthorized
      return      
    end

    game_state = game.game_state
    

    if %i[unit_location move_location].all? { |p| params.key?(p) }
      perform_action(game_state)
    elsif params.key?(:promote_unit_type)
      perform_promote(game_state)
    end
    game.save

    ActionCable.server.broadcast("game_#{game.id}", game.simplified)
  end

  def show
    game = Game.find(params[:id])

    render json: game.simplified
  end

  private

  def perform_action(game_state)
    unit_location = params[:unit_location]
    move_location = params[:move_location]
    unit = game_state.select_actionable_unit(unit_location)
    action = game_state.select_allowed_action(unit, move_location)
    game_state.perform_action(action)
  end

  def perform_promote(game_state)
    promote_unit_type_name = params[:promote_unit_type]
    promote_unit_class = select_promoted_unit_class(promote_unit_type_name)
    promote = game_state.select_promote_action(promote_unit_class)
    game_state.perform_action(promote)
  end

  def select_promoted_unit_class(type_name)
    { 'Queen' => ChessEngine::Units::Queen,
      'Rook' => ChessEngine::Units::Rook,
      'Bishop' => ChessEngine::Units::Bishop,
      'Knight' => ChessEngine::Units::Knight }[type_name.camelize]
  end

  def current_player
    case game_state.curent_color
    when :white
      player1_user
    when :black
      player2_user
    end
  end
end
