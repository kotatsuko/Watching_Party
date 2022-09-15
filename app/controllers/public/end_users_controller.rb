class Public::EndUsersController < ApplicationController

  before_action :ensure_guest_user, except:[:show]
  before_action :show_guest_user, only:[:show]
  before_action :ensure_correct_user, only:[:edit, :update]
  before_action :ensure_deleted_user, only:[:confirm, :deleted]
  after_action :deleted_message, only:[:deleted]
  before_action :end_user_sign_in?


  def show
    @end_user = EndUser.find(params[:id])
    if @end_user == @current_end_user
      @posts = Post.where(end_user_id: [@current_end_user.id, *@current_end_user.followings.pluck(:id)]).order(created_at: :desc)
    else
      @posts = @end_user.posts.order(created_at: :desc)
    end
  end

  def edit
    @end_user = EndUser.find(params[:id])
  end

  def update
    @end_user = EndUser.find(params[:id])
    @end_user.update(end_user_params)
    redirect_to end_user_path(@end_user)
  end

  def confirm
    @end_user = EndUser.find(params[:end_user_id])
  end

  def deleted
     @end_user = EndUser.find(params[:end_user_id])
     @end_user.update(is_deleted: "TRUE")
     reset_session
     redirect_to root_path
  end

  def my_favorites
    post_favorites_ids = PostFavorite.where(end_user_id:@current_end_user.id).pluck(:post_id)
    @posts = Post.order(created_at: :desc).find(post_favorites_ids)
  end

  def my_groups
    @end_user = EndUser.find(params[:end_user_id])
    @groups = @end_user.groups.order(start_time: :desc)
  end

  def my_posts
    @posts = current_end_user.posts.order(created_at: :desc)
  end





  private

  def end_user_params
    params.require(:end_user).permit(:name, :introduction, :end_user_image)
  end

  def ensure_correct_user
    @end_user = EndUser.find(params[:id])
    @current_end_user = current_end_user
    if @end_user != @current_end_user
      redirect_to end_user_path(@end_user),notice:"ほかのユーザーの情報は編集することができません"
    end
  end

  def ensure_deleted_user
    @end_user = EndUser.find(params[:end_user_id])
    @current_end_user = current_end_user
    if @end_user != @current_end_user
      redirect_to end_user_path(@end_user),notice:"ほかのユーザーの情報は編集することができません"
    end
  end


  def ensure_guest_user
    if current_end_user.email == "guest@example.com"
      redirect_to root_path,notice:"ゲストユーザーでは使用できませんできません。"
    end
  end

  def show_guest_user
    @end_user = EndUser.find(params[:id])
    if @end_user.email == "guest@example.com"
      redirect_to root_path,notice:"ゲストユーザーでは使用できませんできません。"
    end
  end

  def end_user_sign_in?
    unless end_user_signed_in?
      redirect_to new_end_user_session_path
      flash[:notice] = "サイトを使用するにはログインをしてください"
    end
  end

  def deleted_message
    flash[:notice] = "退会しました"
  end


end
