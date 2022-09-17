class Admin::PostsController < ApplicationController

  before_action :admin_sign_in?

  layout "admin_application"


  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @post_comments = @post.post_comments
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path
  end

  def comment_destroy
    post = Post.find(params[:post_id])
    post_comment = post.post_comments.find(params[:id])
    post_comment.destroy
    redirect_to admin_post_path(post)
  end



  private


  def admin_sign_in?
    unless admin_signed_in?
      redirect_to new_admin_session_path
      flash[:notice] = "サイトを使用するにはログインをしてください"
    end
  end

end
