class UsersController < ApplicationController
  def update
    p user_params
    game = Game.find(user_params[:game_id])

    player_route = request.path.split('/')[-1]

    if player_route == 'player1'
      game.player1_user_id = user_params[:user_id]
    elsif player_route == 'player2'
      game.player2_user_id = user_params[:user_id]
    end

    game.save
  end

  private

  def user_params
    params.permit(:game_id, :user_id)
  end
end
