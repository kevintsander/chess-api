class GameChannel < ApplicationCable::Channel
  def subscribed
    game_id = params[:game_id]
    stream_from "game_#{game_id}"
    game = Game.find(game_id)
    transmit(game.simplified)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
