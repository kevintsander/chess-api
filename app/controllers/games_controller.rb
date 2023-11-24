class GamesController < ApplicationController
  def create
    player1 = ChessEngine::Player.new('Kevin', :white)
    player2 = ChessEngine::Player.new('Ivy', :black)
    game_state = ChessEngine::Game.new([player1, player2])
    game_state.start
    game = Game.create(game_state:)

    ActionCable.server.broadcast("game_#{game.id}", game.simplified)
    render json: game.simplified
  end

  def update
    id = params[:id]
    unit_location = params[:unit_location]
    move_location = params[:move_location]
    game = Game.find(id)
    game_state = game.game_state
    unit = game_state.select_actionable_unit(unit_location)
    action = game_state.select_allowed_action(unit, move_location)
    game_state.perform_action(action)
    game.save

    ActionCable.server.broadcast("game_#{game.id}", game.simplified)
    render json: game.simplified
  end

  def show
    game = Game.find(params[:id])

    render json: game.simplified
  end
end
