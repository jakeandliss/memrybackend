class Entry < ActiveRecord::Base
  belongs_to :user

  has_many :taggings
  has_many :tags, -> { uniq }, through: :taggings, :dependent => :destroy
  has_many :resources, dependent: :destroy

  validates :title, presence: true

  default_scope { order('title_date DESC', 'created_at DESC') }
end