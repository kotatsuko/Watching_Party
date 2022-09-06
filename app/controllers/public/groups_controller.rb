class Public::GroupsController < ApplicationController

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.end_time = params[:group][:start_time].to_datetime.since(params[:group][:viewing_time].to_i * 60).ago(9 * 60 *60)
    @group.owner_user_id = current_end_user.id
    @group.end_users << current_end_user
    if @group.save
      redirect_to group_path(@group)
    else
      render "new"
    end
  end

  def index
    @groups = Group.all.order(created_at: :desc)
  end

  def show
    @group = Group.find(params[:id])
    @group_comment = GroupComment.new
    @group_comments = @group.group_comments.order(created_at: :desc)
    render :layout => "group_show_application"
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    @group.update(group_params)
    @group.update(end_time: params[:group][:start_time].to_datetime.since(params[:group][:viewing_time].to_i * 60).ago(9 * 60 *60))
    redirect_to group_path(@group)
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to end_user_my_groups_path(current_end_user)
  end

  def popular_index

  end

  def start_index

  end

  def long_index

  end

  def shor_index

  end

  def join
    @group = Group.find(params[:group_id])
    @group.end_users << current_end_user
    redirect_to  request.referer
  end

  def leave
    @group = Group.find(params[:group_id])
    @group.end_users.delete(current_end_user)
    redirect_to  request.referer
  end





  private


  def group_params
    params.require(:group).permit(:name, :introduction, :title, :genre, :viewing_time, :start_time, :group_image)
  end
end
