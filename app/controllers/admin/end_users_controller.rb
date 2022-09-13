class Admin::EndUsersController < ApplicationController

  before_action :admin_sign_in?

  layout "admin_application"


  def index
    @end_users = EndUser.all.order(created_at: :desc)
  end

  def show
    @end_user = EndUser.find(params[:id])
    @posts = @end_user.posts
  end

  def edit
    @end_user = EndUser.find(params[:id])
  end

  def update
    @end_user = EndUser.find(params[:id])
    @end_user.update(end_user_params)
    redirect_to admin_end_user_path
  end



  private


  def end_user_params
    params.require(:end_user).permit(:name, :introduction, :end_user_image, :is_deleted)
  end

  def admin_sign_in?
    unless admin_signed_in?
      redirect_to new_admin_session_path
      flash[:notice] = "サイトを使用するにはログインをしてください"
    end
  end


end
