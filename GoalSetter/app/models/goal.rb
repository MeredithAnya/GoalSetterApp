class Goal < ActiveRecord::Base

  validates :user_id, :description, :title, presence: true
  validates :view_status, inclusion: ["public", "private"]

  belongs_to :user
end
