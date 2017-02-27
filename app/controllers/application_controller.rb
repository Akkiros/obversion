class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

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
end
