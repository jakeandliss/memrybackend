class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_secure_password
  # has_many :entries, :dependent => :destroy
  # 	has_many :tags, :dependent => :destroy

  has_attached_file :avatar, :styles => { :medium => "300x300>", :avatar =>  "150x150#", :thumb => "100x100>" }, :default_url => "blank_avatar.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/, reject_if: :blank

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :password, presence: true

  def send_password_reset
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.zone.now
    save!
  end

end
