class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from Exception, with: :global_exception

  def require_login
    if session[:player_id].nil?
      flash[:notice] = 'login required'
      return redirect_to accounts_path
    end

    player = Player.find_by(id: session[:player_id])
    if player.nil?
      flash[:notice] = 'player is nil'
      return redirect_to accounts_path
    end
  end

  def prohibit_logined_player
    if session[:player_id]
      return redirect_to games_path
    end
  end

  private

  def global_exception(e)
    Rails.logger.error("Exception : #{e.message}")
    redirect_back(fallback_location: accounts_path)
  end
end
