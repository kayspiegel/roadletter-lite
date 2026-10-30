class PasswordsController < ApplicationController
  layout "auth"

  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]
  rate_limit to: 10, within: 3.minutes, only: %i[ create update ], with: :too_many_requests

  def new
  end

  # The same page for every address, so nobody learns whether it has an account.
  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    @email_address = params[:email_address]
    render :sent
  end

  def edit
  end

  def update
    if @user.reset_password(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: t(".notice")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      render :expired, status: :gone
    end

    def too_many_requests
      flash.now[:alert] = t("passwords.create.rate_limited")
      render action_name == "create" ? :new : :edit, status: :too_many_requests
    end
end
