class Public::GroupCommentsController < ApplicationController

  before_action :ensure_guest_user
  before_action :end_user_sign_in?


  def create
    group = Group.find(params[:group_id])
    @group_comment = GroupComment.new(group_comment_params)
    @group_comment.end_user_id = current_end_user.id
    @group_comment.group_id = group.id
    if @group_comment.save
      #ActionCableを用いてグループコメントを送信
      ActionCable.server.broadcast 'live_channel', {group_comment: @group_comment.template}
    else
      render "groups/show"
    end
  end

  def destroy
    group = Group.find(params[:group_id])
    group_comment = group.group_comments.find(params[:id])
    group_comment.destroy
    redirect_to group_path(group)
  end





  private

  def group_comment_params
    params.require(:group_comment).permit(:body)
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
