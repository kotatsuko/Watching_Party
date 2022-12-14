class EndUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :own_groups, class_name: "Group", foreign_key: "owner_user_id"
  has_many :group_comments
  has_many :posts, dependent: :destroy
  has_many :post_favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  validates :name, presence: true, length: { maximum: 50 }

  #ユーザー画像
  has_one_attached :end_user_image
  #ユーザー画像の
  def get_end_user_image
    (end_user_image.attached?) ? end_user_image : 'no_image.jpg'
  end


  #フォローをする処理
  def follow(end_user_id)
    relationships.create(followed_id: end_user_id)
  end

  #フォローを外す処理
  def unfollow(end_user_id)
    relationships.find_by(followed_id: end_user_id).destroy
  end

  #フォローしているかを判定
  def following?(end_user)
    followings.include?(end_user)
  end

  #検索用の処理
  def self.looks(word)
    EndUser.where("name LIKE? or introduction LIKE?", "%#{word}%", "%#{word}%")
  end

  #ゲストログイン用の処理
  def self.guest
    find_or_create_by!(email:"guest@example.com") do |end_user|
      end_user.password=SecureRandom.urlsafe_base64
      end_user.name="ゲストユーザー"
    end
  end

end
