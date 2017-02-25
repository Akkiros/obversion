class AccountsController < ApplicationController
  before_action :encrypt_password, only: [:create, :login]

  def index
  end

  def new
  end

  def create
    player = Player.new(account_params)

    if player.valid? && player.save
      session[:player_id] = player.id

      return redirect_to games_path
    end

    puts player.errors.messages
    # TODO: flash notice error message
    return redirect_back(fallback_location: accounts_new_path)
  end

  def login
    player = Player.find_by(username: params[:accounts][:username])

    if player.nil?
      puts 'player is nil'
      # TODO: flash notice error message
      return redirect_to action: 'index'
    end

    unless player.password == params[:accounts][:password]
      puts 'password is not matched'
      return redirect_to action: 'index'
    end

    session[:player_id] = player.id

    redirect_to games_path
  end

  def logout
    reset_session
    redirect_to action: 'index'
  end

  private

  def encrypt_password
    params[:accounts][:password] = Player.encrypt_password(params[:accounts][:password])
  end

  def account_params
    params.require(:accounts).permit(:username, :password)
  end
end
