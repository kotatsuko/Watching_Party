class Admin::HomesController < ApplicationController

  layout "admin_application"

  def top
    #視聴待ちのグループの中で参加人数が多いものを上から三つ変数に定義
    @pickup_groups = Group.limit(3).where("start_time > ?", Time.now).sort{|a,b|
      b.end_users.count <=>
      a.end_users.count
    }

    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    
    #一週間で多くいいねされたもの上から四つ変数に定義
    @pickup_posts = Post.includes(:post_favorites).limit(4).sort {|a,b|
        b.post_favorites.where(created_at: from...to).size <=>
        a.post_favorites.where(created_at: from...to).size
      }
  end

end
