class Public::PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.end_user_id = current_end_user.id
    if @post.save
      redirect_to post_path(@post)
    else
      @posts = Post.all.order(created_at: :desc)
      render 'index'
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @post_comments = @post.post_comments
  end

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def popular_index
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @posts = Post.includes(:post_favorites).
      sort {|a,b|
        b.post_favorites.where(created_at: from...to).size <=>
        a.post_favorites.where(created_at: from...to).size
      }
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to end_user_path(@post.end_user)
  end








  private


  def post_params
    params.require(:post).permit(:body)
  end
end
