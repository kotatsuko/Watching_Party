class Post < ApplicationRecord

  belongs_to :end_user
  has_many :post_comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :body, presence: true


  #いいねさているかの判定
  def favorited_by?(end_user)
    post_favorites.exists?(end_user_id: end_user.id)
  end

  #検索用の処理
  def self.looks(word)
    Post.where("body LIKE?", "%#{word}%")
  end
  
  
  #タグの保存の処理
  def save_tag(sent_tags)
    #タグが入力されていたら現在のタグを変数に定義
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    #現在のタグの中から送信されたタグにあるものを削除したものの一覧を変数に定義
    old_tags = current_tags - sent_tags
    #送信されたタグの中から現在のタグにあるものを削除したものの一覧を変数に定義
    new_tags = sent_tags - current_tags
    
    #すでにあるものを検索し削除
    old_tags.each do |old|
      self.tags.delete　Tag.find_by(name: old)
    end
    
    #新しいタグを作成し投稿に追加
    new_tags.each do |new|
      new_book_tag = Tag.find_or_create_by(name: new)
      self.tags << new_book_tag
    end
  end

end
