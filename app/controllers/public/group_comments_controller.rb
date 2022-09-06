class Public::GroupCommentsController < ApplicationController

  def create
    group = Group.find(params[:group_id])
    @group_comment = GroupComment.new(group_comment_params)
    @group_comment.end_user_id = current_end_user.id
    @group_comment.group_id = group.id
    if @group_comment.save
      ActionCable.server.broadcast 'live_channel', {group_comment: @group_comment.template}
    else
      render "groups/show"
    end
  end



  private

  def group_comment_params
    params.require(:group_comment).permit(:body)
  end



end
