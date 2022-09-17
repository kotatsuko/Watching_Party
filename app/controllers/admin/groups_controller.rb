class Admin::GroupsController < ApplicationController

  before_action :admin_sign_in?

  layout "admin_application"



  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    #終了時間の計算
    @group.end_time = params[:group][:start_time].to_datetime.since(params[:group][:viewing_time].to_i * 60).ago(9 * 60 *60)
    #admin用のオーナーIDの設定
    @group.owner_user_id = 4
    #送信されたタグを変数に定義
    tag_list=params[:group][:tag_name].split(nil)
    if @group.save
      #タグの保存
      @group.save_tag(tag_list)
      redirect_to admin_group_path(@group)
    else
      render "new"
    end
  end


  def index
    @groups = Group.all.order(created_at: :desc)
  end

  def show
    @group = Group.find(params[:id])
    @group_comments = @group.group_comments
    render :layout => "admin_group_show_application"
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    #送信されたタグを変数に定義
    tag_list=params[:group][:tag_name].split(nil)
    if @group.update(group_params)
      #終了時間の再計算
      @group.update(end_time: params[:group][:start_time].to_datetime.since(params[:group][:viewing_time].to_i * 60).ago(9 * 60 *60))
      #タグの再設定
      @group.save_tag(tag_list)
      redirect_to admin_group_path(@group)
    else
      render "edit"
    end
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
  
  #視聴待ちのグループを参加人数順に並べ替え
  def popular_index
    @groups = Group.where("start_time > ?", Time.now).sort{|a,b|
      b.end_users.count <=>
      a.end_users.count
    }
  end
  
  #視聴待ちのグループを開始時間が近い順に並べ替え
  def start_index
    @groups = Group.where("start_time > ?", Time.now).order(start_time: :asc)
  end
  
  #視聴待ちのグループを視聴時間が長い順に並べ替え
  def long_index
    @groups = Group.where("start_time > ?", Time.now).order(viewing_time: :desc)
  end
  
  #視聴待ちのグループを視聴時間が短い順に並べ替え
  def short_index
    @groups = Group.where("start_time > ?", Time.now).order(viewing_time: :asc)
  end
  
  #視聴が終了したグループを現在時刻から近い順に並べ替え
  def closed_index
    @groups = Group.where("end_time < ?", Time.now).order(end_time: :desc)
  end





  private


  def group_params
    params.require(:group).permit(:name, :introduction, :title, :genre, :viewing_time, :start_time, :group_image)
  end

  def admin_sign_in?
    unless admin_signed_in?
      redirect_to new_admin_session_path
      flash[:notice] = "サイトを使用するにはログインをしてください"
    end
  end

end
