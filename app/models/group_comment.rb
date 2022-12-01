class GroupComment < ApplicationRecord

  belongs_to :end_user
  belongs_to :group


  validates :body, presence: true, length: { maximum: 200 }

  #ActionCableで送信する際のコメントのテンプレート化
  def template
    ApplicationController.renderer.render partial: 'public/group_comments/group_comment', locals: { group_comment: self, current_end_user:@current_end_user }
  end

end
