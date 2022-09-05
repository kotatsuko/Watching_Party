class Public::EndUsersController < ApplicationController

  def show
    @current_end_user = current_end_user
    @starting_soon_groups = Group.where("start_time > ?", Time.now).order(start_time: :asc).limit(3)
    @watching_groups = Group.where("end_time > ? and ? > start_time", Time.now, Time.now).limit(3)
    @end_user = EndUser.find(params[:id])
    if @end_user == @current_end_user
      @posts = Post.where(end_user_id: [@current_end_user.id, *@current_end_user.followings.pluck(:id)]).order(created_at: :desc)
    else
      @posts = @end_user.posts.order(created_at: :desc)
    end
  end

  def edit
    @current_end_user = current_end_user
    @starting_soon_groups = Group.where("start_time > ?", Time.now).order(start_time: :asc).limit(3)
    @watching_groups = Group.where("end_time > ? and ? > start_time", Time.now, Time.now).limit(3)
    @end_user = EndUser.find(params[:id])
  end

  def update
    @end_user = EndUser.find(params[:id])
    @end_user.update(end_user_params)
    redirect_to end_user_path(@end_user)
  end

  def confirm
    @current_end_user = current_end_user
    @starting_soon_groups = Group.where("start_time > ?", Time.now).order(start_time: :asc).limit(3)
    @watching_groups = Group.where("end_time > ? and ? > start_time", Time.now, Time.now).limit(3)
  end

  def deleted
     @current_end_user = current_end_user
     @current_end_user.update(is_deleted: "TRUE")
     redirect_to destroy_end_user_session_path
  end

  def my_favorites
    @current_end_user = current_end_user
    @starting_soon_groups = Group.where("start_time > ?", Time.now).order(start_time: :asc).limit(3)
    @watching_groups = Group.where("end_time > ? and ? > start_time", Time.now, Time.now).limit(3)
    post_favorites_ids = PostFavorite.where(end_user_id:@current_end_user.id).pluck(:post_id)
    @posts = Post.order(created_at: :desc).find(post_favorites_ids)
  end

  def my_groups
    @current_end_user = current_end_user
    @starting_soon_groups = Group.where("start_time > ?", Time.now).order(start_time: :asc).limit(3)
    @watching_groups = Group.where("end_time > ? and ? > start_time", Time.now, Time.now).limit(3)
    @groups = current_end_user.groups.order(start_time: :desc)
  end

  def my_posts
    @current_end_user = current_end_user
    @starting_soon_groups = Group.where("start_time > ?", Time.now).order(start_time: :asc).limit(3)
    @watching_groups = Group.where("end_time > ? and ? > start_time", Time.now, Time.now).limit(3)
    @posts = current_end_user.posts.order(created_at: :desc)
  end





  private

  def end_user_params
    params.require(:end_user).permit(:name, :introduction, :end_user_image)
  end

end
