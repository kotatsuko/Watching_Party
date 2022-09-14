# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :end_user_state, only: [:create]
  after_action :login_message, only:[:create, :guest_sign_in]
  after_action :logout_message, only:[:destroy]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def guest_sign_in
    end_user = EndUser.guest
    sign_in end_user
    redirect_to root_path
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end


  protected

  def end_user_state
    @end_user = EndUser.find_by(email: params[:end_user][:email])
    return if !@end_user
    if @end_user.valid_password?(params[:end_user][:password]) && @end_user.is_deleted
      redirect_to new_end_user_registration_path
      reset_session
      flash[:notice] = "退会済みです。再度ご登録をしてご利用ください。"
    end
  end

  def login_message
    flash[:notice] = "ログインしました"
  end

  def logout_message
    flash[:notice] = "ログアウトしました"
  end


end
