require 'openssl'

class UsersController < ApplicationController
  def index
    @users = User.find(current_user.id)
    if @users
      render json: { users: @users }
    else
      render json: { status: 500, errors: ['no users found'] }
    end
  end

  def show
    @user = User.find(params[:id])
    if @user && @user.id == current_user.id
      render json: { user: @user }
    else
      render json: { status: 500, errors: ['user not found'] }
    end
  end

  def create
    @user = User.new(user_params)
    create_new_keys(@user)
    if @user.save
      login!
      render json: { status: :created, user: @user }
    else
      render json: { status: 500, errors: @user.errors.full_messages }
    end
  end

  private

  def create_new_keys(user)
    rsa_key = OpenSSL::PKey::RSA.new(1024)
    user.private_key = rsa_key.to_pem
    user.public_key = rsa_key.public_key.to_pem
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
