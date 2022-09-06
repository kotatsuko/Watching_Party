class Public::SearchesController < ApplicationController

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

end
