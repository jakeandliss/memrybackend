class User < ActiveRecord::Base
  has_many :entries, dependent: destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, :styles => { :medium => "300x300>", :avatar =>  "150x150#", :thumb => "100x100>" }, :default_url => "blank_avatar.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/, reject_if: :blank

  validates :first_name, :last_name, :email, :password, presence: true

end
