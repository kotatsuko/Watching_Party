class Post < ApplicationRecord

  belongs_to :end_user
  has_many :post_comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags



  def favorited_by?(end_user)
    post_favorites.exists?(end_user_id: end_user.id)
  end

end
