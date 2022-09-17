# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  layout "admin_application"

  after_action :login_message, only:[:create]
  after_action :logout_message, only:[:destroy]





  protected
  
  def after_sign_in_path_for(resource)
    admin_path
  end

  def after_sign_out_path_for(resource)
    admin_path
  end

  def login_message
    flash[:notice] = "ログインしました"
  end

  def logout_message
    flash[:notice] = "ログアウトしました"
  end

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

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
