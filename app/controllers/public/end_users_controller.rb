class Public::EndUsersController < ApplicationController

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

  end

  def deleted
     @current_end_user = current_end_user
     @current_end_user.update(is_deleted: "TRUE")
     redirect_to destroy_end_user_session_path
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

end
