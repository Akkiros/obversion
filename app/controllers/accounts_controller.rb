class AccountsController < ApplicationController
  def index
  end

  def new
  end

  def create
    # TODO: password encrypt
    if params[:accounts][:password] != params[:accounts][:password_repeat]
      return redirect_back(fallback_location: accounts_new_path)
    end

    player = Player.new(account_params)

    unless player.valid? || player.save
      # TODO: flash notice error message
      return redirect_to :back
    end

    redirect_to action: 'index'
  end

  def login
    player = Player.find_by(account_params)

    if player.nil?
      # TODO: flash notice error message
      return redirect_to action: 'index'
    end

    session[:player_id] = player.id

    redirect_to controller: 'games', action: 'index'
  end

  def logout
    reset_session
    redirect_to action: 'index'
  end

  private

  def account_params
    params.require(:accounts).permit(:username, :password)
  end
end
