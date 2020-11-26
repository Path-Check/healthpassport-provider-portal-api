# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    @user = User.find_by(email: session_params[:email])

    if @user&.authenticate(session_params[:password])
      login!
      render json: { logged_in: true, user: @user.to_json(only: %i[id email]) }
    else
      render status: 401, json: { errors: ['Invalid credentials', 'Please try again'] }
    end
  end

  def check_logged_in?
    if logged_in? && current_user
      render json: { logged_in: true, user: current_user.to_json(only: %i[id email]) }
    else
      render json: { logged_in: false, message: 'Not logged in' }
    end
  end

  def destroy
    logout!
    render json: {
      status: 200,
      logged_out: true
    }
  end

  private

  def session_params
    params.require(:user).permit(:email, :password)
  end
end
