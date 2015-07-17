class Entry < ActiveRecord::Base
  belongs_to :user

  has_many :taggings
  has_many :tags, -> { uniq }, through: :taggings, :dependent => :destroy
  has_many :resources, dependent: :destroy

  validates :title, presence: true

  default_scope { order('title_date DESC', 'created_at DESC') }

  # Get names of all tags related to this title
  def all_tags
    tags.map(&:name).join(", ")
  end

  # Retrive all titles having with tag or child of this tag
  def self.childrens_of tag
    # Get identifiers of specified tag and its children
    title_ids = Tagging.where(tag_id: tag.subtree_ids).pluck(:entry_id)
    # Find titles with ids from the array title_ids
    Entry.where(id: title_ids.uniq)
  end

end