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


  has_one_attached :group_image
  def get_group_image
    (group_image.attached?) ? group_image : 'no_image.jpg'
  end

  def watching?
    Time.now.between?(self.start_time, self.end_time)
  end

  def waiting?
    (nil .. self.start_time).cover? Time.now
  end

  def closed?
    (self.end_time .. nil).cover? Time.now
  end


  def self.looks(word)
    Group.where("name LIKE? or title LIKE? or introduction LIKE?", "%#{word}%", "%#{word}%", "%#{word}%")
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



  enum genre: { テレビ番組: 0, インターネットコンテンツ: 1, dvd_blu_ray: 2 }

end
