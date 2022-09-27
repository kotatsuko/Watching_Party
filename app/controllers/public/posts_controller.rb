class Public::PostsController < ApplicationController

  before_action :ensure_guest_user, only:[:new, :create, :edit, :update, :destroy]
  before_action :ensure_correct_user, only:[:edit, :update]
  before_action :end_user_sign_in?



  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    #投稿したユーザーのIDを設定
    @post.end_user_id = current_end_user.id
    #送信されたタグを変数に定義
    tag_list=params[:post][:tag_name].split(/ |　/)
    if @post.save
      #タグの保存
      @post.save_tag(tag_list)
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @post_comments = @post.post_comments.order(created_at: :desc)
  end

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  # #一週間で多くいいねされた順に並べ替え
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
    #送信されたタグを変数に定義
    tag_list=params[:post][:tag_name].split(/ |　/)
    if @post.update(post_params)
      #タグの再設定
      @post.save_tag(tag_list)
      redirect_to post_path(@post)
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to end_user_my_posts_path(@post.end_user)
  end








  private


  def post_params
    params.require(:post).permit(:body)
  end

  def ensure_guest_user
    if current_end_user.email == "guest@example.com"
      redirect_to posts_path,notice:"ゲストユーザーでは使用できません。"
    end
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    @current_end_user = current_end_user
    if @post.end_user != @current_end_user
      redirect_to post_path(@post),notice:"ほかのユーザーの投稿は編集できません"
    end
  end


  def end_user_sign_in?
    unless end_user_signed_in?
      redirect_to new_end_user_session_path
      flash[:notice] = "サイトを使用するにはログインをしてください"
    end
  end

end
