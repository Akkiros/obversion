class AccountsController < ApplicationController
  def index
  end

  def new
  end

  def create
    player = Player.new(account_new_params)
    unless player.save
      return redirect_to :back
    end

    redirect_to action: 'index'
  end

  def login
    player = Player.find_by(account_login_params)

    if player.nil?
      return redirect_to action: 'index'
    end

    session[:player_id] = player.id
  end

  def logout
    reset_session
  end

  private

  def account_new_params
    params.require(:account).permit(:username, :password, :password_repeat)
  end

  def account_login_params
    params.require(:account).permit(:username, :password)
  end
end
