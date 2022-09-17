class Group < ApplicationRecord

  has_many :group_users, dependent: :destroy
  has_many :end_users, through: :group_users
  has_many :group_comments, dependent: :destroy
  has_many :group_tags, dependent: :destroy
  has_many :tags, through: :group_tags


  validates :name, presence: true
  validates :introduction, presence: true
  validates :title, presence: true
  validates :genre, presence: true
  validates :start_time, presence: true
  validates :viewing_time, presence: true


  #グループ画像
  has_one_attached :group_image
  #グループ画像の呼び出し
  def get_group_image
    (group_image.attached?) ? group_image : 'no_image.jpg'
  end

  #視聴中の判定
  def watching?
    Time.now.between?(self.start_time, self.end_time)
  end

  #視聴待ちの判定
  def waiting?
    (nil .. self.start_time).cover? Time.now
  end

  #視聴終了の判定
  def closed?
    (self.end_time .. nil).cover? Time.now
  end

  #検索用の処理
  def self.looks(word)
    Group.where("name LIKE? or title LIKE? or introduction LIKE?", "%#{word}%", "%#{word}%", "%#{word}%")
  end

  #タグの保存の処理
  def save_tag(sent_tags)
    #タグが入力されていたら現在のタグを変数に定義
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    #現在のタグの中から送信されたタグにあるものを削除したものの一覧を変数に定義
    old_tags = current_tags - sent_tags
    #送信されたタグの中から現在のタグにあるものを削除したものの一覧を変数に定義
    new_tags = sent_tags - current_tags

    #すでにあるものを検索しグループから削除
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    #新しいタグを作成しグループに追加
    new_tags.each do |new|
      new_book_tag = Tag.find_or_create_by(name: new)
      self.tags << new_book_tag
    end
  end


  #ジャンル用の定義
  enum genre: { テレビ番組: 0, インターネットコンテンツ: 1, dvd_blu_ray: 2 }

end
