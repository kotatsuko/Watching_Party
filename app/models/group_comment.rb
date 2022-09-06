class GroupComment < ApplicationRecord

  belongs_to :end_user
  belongs_to :group


  validates :body, presence: true, length: { maximum: 200 }

  def template
    ApplicationController.renderer.render partial: 'public/group_comments/group_comment', locals: { group_comment: self }
  end

end
