class Admin::GroupsController < ApplicationController

  layout "admin_application"


  def index
    @groups = Group.all.order(created_at: :desc)
  end

  def show
    @group = Group.find(params[:id])
    @group_comments = @group.group_comments
    render :layout => "admin_group_show_application"
  end

  def create
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to admin_groups_path
  end

  def comment_destroy
    group = Group.find(params[:group_id])
    group_comment = group.group_comments.find(params[:id])
    group_comment.destroy
    redirect_to admin_group_path(group)
  end

  def popular_index
    @groups = Group.where("start_time > ?", Time.now).sort{|a,b|
      b.end_users.count <=>
      a.end_users.count
    }
  end

  def start_index
    @groups = Group.where("start_time > ?", Time.now).order(start_time: :asc)
  end

  def long_index
    @groups = Group.where("start_time > ?", Time.now).order(viewing_time: :desc)
  end

  def short_index
    @groups = Group.where("start_time > ?", Time.now).order(viewing_time: :asc)
  end

  def closed_index
    @groups = Group.where("end_time < ?", Time.now).order(end_time: :desc)
  end

end
