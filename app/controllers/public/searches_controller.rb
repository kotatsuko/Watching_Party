class Public::SearchesController < ApplicationController

  before_action :user_sign_in?



  def search
    #グループで検索した場合
    if params[:data_type] == "グループ"
      @groups = Group.looks(params[:word])
    #投稿で検索した場合
    elsif params[:data_type] == "投稿"
      @posts = Post.looks(params[:word]
    #ユーザーで検索した場合
    elsif params[:data_type] == "ユーザー"
      @end_users = EndUser.looks(params[:word])
    end
    @word = params[:word]
    @data_type = params[:data_type]
    #adminだった場合のレイアウト
    if admin_signed_in?
      render :layout => "admin_application"
    end
  end

  def tag_search
    @tag = Tag.find(params[:id])
    @groups = @tag.groups.order(created_at: :desc)
    @posts = @tag.posts.order(created_at: :desc)
    #adminだった場合のレイアウト
    if admin_signed_in?
      render :layout => "admin_application"
    end
  end



  private

  def user_sign_in?
    if !end_user_signed_in? && !admin_signed_in?
      redirect_to root_path
      flash[:notice] = "サイトを使用するにはログインをしてください"
    end
  end

end
