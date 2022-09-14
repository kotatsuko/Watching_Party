class Public::PostCommentsController < ApplicationController
  
  before_action :ensure_guest_user
  before_action :end_user_sign_in?
  
  
  

  def create
    @post = Post.find(params[:post_id])
    comment = current_end_user.post_comments.new(post_comment_params)
    comment.post_id = @post.id
    comment.save
    redirect_to post_path(@post)
  end

  def destroy
    PostComment.find(params[:id]).destroy
    @post=Post.find(params[:post_id])
    redirect_to post_path(@post)
  end



  private

  def post_comment_params
    params.require(:post_comment).permit(:body)
  end
  
  def ensure_guest_user
    if current_end_user.email == "guest@example.com"
      redirect_to request.referer,notice:"ゲストユーザーでは使用できませんできません。"
    end
  end
  
  def end_user_sign_in?
    unless end_user_signed_in?
      redirect_to new_end_user_session_path
      flash[:notice] = "サイトを使用するにはログインをしてください"
    end
  end

end
