class Public::GroupsController < ApplicationController

  before_action :ensure_guest_user, only:[:new, :create, :edit, :update, :destroy]
  before_action :ensure_owner_user, only:[:edit, :update]
  before_action :end_user_sign_in?


  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    #終了時間の計算
    @group.end_time = params[:group][:start_time].to_datetime.since(params[:group][:viewing_time].to_i * 60).ago(9 * 60 *60)
    #オーナーユーザーの定義
    @group.owner_user_id = current_end_user.id
    #グループを作成したユーザーをグループに参加させる
    @group.end_users << current_end_user
    #送信されたタグを変数に定義
    tag_list=params[:group][:tag_name].split(/ |　/)
    if @group.save
      #タグの保存
      @group.save_tag(tag_list)
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
    #groups/show用のレイアウト設定
    render :layout => "group_show_application"
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    #送信されたタグを変数に定義
    tag_list=params[:group][:tag_name].split(/ |　/)
    if @group.update(group_params)
      #終了時間の再計算
      @group.update(end_time: params[:group][:start_time].to_datetime.since(params[:group][:viewing_time].to_i * 60).ago(9 * 60 *60))
      #タグの再設定
      @group.save_tag(tag_list)
      redirect_to group_path(@group)
    else
      render "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to end_user_my_groups_path(current_end_user)
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

  #グループに参加する処理
  def join
    @group = Group.find(params[:group_id])
    @group.end_users << current_end_user
    @group_comments = @group.group_comments.order(created_at: :desc)
  end

  #グループから抜ける処理
  def leave
    @group = Group.find(params[:group_id])
    @group.end_users.delete(current_end_user)

  end





  private


  def group_params
    params.require(:group).permit(:name, :introduction, :title, :genre, :viewing_time, :start_time, :group_image)
  end

  def ensure_owner_user
    @current_end_user = current_end_user
    @group = Group.find(params[:id])
    if @group.owner_user_id != @current_end_user.id
      redirect_to groups_path
      flash[:notice] = "オーナーユーザーのみグループの情報を編集できます。"
    end
  end

  def ensure_guest_user
    if current_end_user.email == "guest@example.com"
      redirect_to groups_path
      flash[:notice] = "ゲストユーザーでは使用できません。"
    end
  end

  def end_user_sign_in?
    unless end_user_signed_in?
      redirect_to new_end_user_session_path
      flash[:notice] = "サイトを使用するにはログインをしてください"
    end
  end

end
