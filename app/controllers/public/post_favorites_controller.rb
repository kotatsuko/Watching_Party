class Public::PostFavoritesController < ApplicationController

  before_action :ensure_guest_user
  before_action :end_user_sign_in?


  def create
    post = Post.find(params[:post_id])
    post_favorite = current_end_user.post_favorites.new(post_id: post.id)
    post_favorite.save
    redirect_to request.referer
  end

  def destroy
    post = Post.find(params[:post_id])
    post_favorite = current_end_user.post_favorites.find_by(post_id: post.id)
    post_favorite.destroy
    redirect_to request.referer
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
