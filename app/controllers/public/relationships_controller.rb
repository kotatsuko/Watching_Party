class Public::RelationshipsController < ApplicationController

  before_action :ensure_guest_user
  before_action :end_user_sign_in?



  # フォローするとき
  def create
    current_end_user.follow(params[:end_user_id])
    redirect_to request.referer
  end
  # フォロー外すとき
  def destroy
    current_end_user.unfollow(params[:end_user_id])
    redirect_to request.referer
  end
  # フォロー一覧
  def followings
    @end_user = EndUser.find(params[:end_user_id])
    @end_users = @end_user.followings.where(is_deleted:false)
  end
  # フォロワー一覧
  def followers
    @end_user = EndUser.find(params[:end_user_id])
    @end_users = @end_user.followers.where(is_deleted:false)
  end



  private

  def ensure_guest_user
    if current_end_user.email == "guest@example.com"
      redirect_to request.referer,notice:"ゲストユーザーでは使用できません。"
    end
  end

  def end_user_sign_in?
    unless end_user_signed_in?
      redirect_to new_end_user_session_path
      flash[:notice] = "サイトを使用するにはログインをしてください"
    end
  end

end
