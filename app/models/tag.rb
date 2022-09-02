class Tag < ApplicationRecord

  has_many :post_tags, dependent: :destroy
  has_many :post, through: :post_tags
  has_many :group_tags, dependent: :destroy
  has_many :group, through: :group_tags

end
