class SessionsController < ApplicationController
  before_action :require_logged_in, only: [:destroy]
  before_action :require_logged_out, only: [:new, :create]

  def create
    @user = User.new(user_params)
    if @user.save
      @user.reset_session_token
      redirect_to user_url(@user)
    else
      flash.now[:errors]= @user.errors.full_messages
      render :new
    end
  end

end
