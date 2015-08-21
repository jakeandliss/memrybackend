class Blog < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true

  default_scope { order('created_at DESC')}

  extend FriendlyId
  friendly_id :title, use: :slugged
end
