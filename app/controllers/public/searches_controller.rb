class Public::SearchesController < ApplicationController

  before_action :end_user_sign_in?



  def search
    if params[:data_type] == "グループ"
      @groups = Group.looks(params[:word])
    elsif params[:data_type] == "投稿"
      @posts = Post.looks(params[:word])
    elsif params[:data_type] == "ユーザー"
      @end_users = EndUser.looks(params[:word])
    end
    @word = params[:word]
    @data_type = params[:data_type]
  end

  def tag_search
    @tag = Tag.find(params[:id])
    @groups = @tag.groups.order(created_at: :desc)
    @posts = @tag.posts.order(created_at: :desc)
  end



  private

  def end_user_sign_in?
    unless end_user_signed_in?
      redirect_to new_end_user_session_path
      flash[:notice] = "サイトを使用するにはログインをしてください"
    end
  end

end
