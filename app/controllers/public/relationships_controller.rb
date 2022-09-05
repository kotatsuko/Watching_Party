class Public::RelationshipsController < ApplicationController

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
    @current_end_user = current_end_user
    @starting_soon_groups = Group.where("start_time > ?", Time.now).order(start_time: :asc).limit(3)
    @watching_groups = Group.where("end_time > ? and ? > start_time", Time.now, Time.now).limit(3)
    @end_user = EndUser.find(params[:end_user_id])
    @end_users = @end_user.followings
  end
  # フォロワー一覧
  def followers
    @current_end_user = current_end_user
    @starting_soon_groups = Group.where("start_time > ?", Time.now).order(start_time: :asc).limit(3)
    @watching_groups = Group.where("end_time > ? and ? > start_time", Time.now, Time.now).limit(3)
    @end_user = EndUser.find(params[:end_user_id])
    @end_users = @end_user.followers
  end

end
