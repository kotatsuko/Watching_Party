class Admin::HomesController < ApplicationController

  layout "admin_application"

  def top
    @pickup_groups = Group.limit(3).where("start_time > ?", Time.now).sort{|a,b|
      b.end_users.count <=>
      a.end_users.count
    }

    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @pickup_posts = Post.includes(:post_favorites).limit(4).sort {|a,b|
        b.post_favorites.where(created_at: from...to).size <=>
        a.post_favorites.where(created_at: from...to).size
      }
  end

end
