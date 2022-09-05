class Group < ApplicationRecord

  has_many :group_users, dependent: :destroy
  has_many :end_users, through: :group_users
  has_many :group_comments, dependent: :destroy
  has_many :group_tags, dependent: :destroy
  has_many :tags, through: :end_user_info

  has_one_attached :group_image
  def get_group_image
    (group_image.attached?) ? group_image : 'no_image.jpg'
  end
  
  def watching?
    Time.now.between?(self.start_time, self.end_time)
  end



  enum genre: { テレビ番組: 0, インターネットコンテンツ: 1, dvd_blu_ray: 2 }

end
