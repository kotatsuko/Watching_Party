class Public::HomesController < ApplicationController




  def top
    #視聴待ちのグループの中で参加人数が多いものを上から三つ変数に定義
    @pickup_groups = Group.limit(3).where("start_time > ?", Time.now).sort{|a,b|
      b.end_users.count <=>
      a.end_users.count
    }

    #一週間で多くいいねされたもの上から四つ変数に定義
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @pickup_posts = Post.where(created_at: from...to).where("score > ?" , 0.5).order(score: :desc).limit(4)
  end

  def about

  end

end
