class Public::SearchesController < ApplicationController
  
  def search
    if params[:data_type] == "グループ"
      @results = Group.looks(params[:word])
    elsif params[:data_type] == "投稿"
      @results = Post.looks(params[:word])
    elsif params[:data_type] == "ユーザー"
      @results = EndUser.looks(params[:word])
    end
    @word = params[:word]
    @data_type = params[:data_type]
  end
  
end
