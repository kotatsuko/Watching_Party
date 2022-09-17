class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :setting



  def setting
    @current_end_user = current_end_user
    #開始時間が近いグループを三つ変数に定義
    @starting_soon_groups = Group.where("start_time > ?", Time.now).order(start_time: :asc).limit(3)
    #視聴中のグループを最大三つ変数に定義
    @watching_groups = Group.where("end_time > ? and ? > start_time", Time.now, Time.now).limit(3)
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

end
