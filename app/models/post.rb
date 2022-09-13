class Post < ApplicationRecord

  belongs_to :end_user
  has_many :post_comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :body, presence: true



  def favorited_by?(end_user)
    post_favorites.exists?(end_user_id: end_user.id)
  end


  def self.looks(word)
    Post.where("body LIKE?", "%#{word}%")
  end

  def save_tag(sent_tags)

    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete　Tag.find_by(name: old)
    end

    new_tags.each do |new|
      new_book_tag = Tag.find_or_create_by(name: new)
      self.tags << new_book_tag
    end
  end

end
