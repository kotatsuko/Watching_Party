class Admin::GroupsController < ApplicationController

  layout "admin_application"
  
  
  def index
    @groups = Group.all.order(created_at: :desc)
  end
  
  def show
    @group = Group.find(params[:id])
    @group_comments = @group.group_comments
  end
  
  def create
  end
  
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to admin_groups_path
  end
  
  def popular_index
    @groups = Group.sort{|a,b|
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

end
