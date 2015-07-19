class Tag < ActiveRecord::Base
  validates :name, presence: true
  validates :user_id, uniqueness: { scope: :name }

  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :entries, -> { uniq }, through: :taggings
  has_ancestry

  def update_tag!(tag_attr)
    self.update_attributes!(tag_attr)
  end

  class << self
    def counts
      self.select("name, count(taggings.tag_id) as count").joins(:taggings).group("taggings.tag_id")
    end

    def hierarchy_tree
      self.arrange_serializable.to_json(:only => ["id","name", "children"])
    end

    def create_tag!(tag_attr)
      Tag.create!(tag_attr)
    end
  end
end

