class Tag < ApplicationRecord

  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags
  has_many :group_tags, dependent: :destroy
  has_many :groups, through: :group_tags

end
