class Public::HomesController < ApplicationController

  def top
    @current_end_user = current_end_user
    @starting_soon_groups = Group.where("start_time > ?", Time.now).order(start_time: :asc).limit(3)
    @watching_groups = Group.where("end_time > ? and ? > start_time", Time.now, Time.now).limit(3)
  end

  def about
    @current_end_user = current_end_user
    @starting_soon_groups = Group.where("start_time > ?", Time.now).order(start_time: :asc).limit(3)
    @watching_groups = Group.where("end_time > ? and ? > start_time", Time.now, Time.now).limit(3)
  end

end
