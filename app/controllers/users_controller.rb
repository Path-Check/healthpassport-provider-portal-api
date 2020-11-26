# frozen_string_literal: true

require 'openssl'

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    if @user && @user.id == current_user.id
      render json: { user: @user.to_json(only: %i[id email]) }
    else
      render status: 500, json: { errors: ['User not found'] }
    end
  end

  def create
    @user = User.new(user_params)
    create_new_keys(@user)
    if @user.save
      login!
      render json: { status: :created, user: @user.to_json(only: %i[id email]) }
    else
      render status: 500, json: { errors: @user.errors.full_messages }
    end
  end

  def pub_key
    @user = User.find(params[:id])
    if @user
      render plain: @user.public_key
    else
      render status: 500, json: { errors: ['User not found'] }
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
