class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  has_many :courses, dependent: :destroy
  has_many :programs, dependent: :destroy
  has_many :carts, foreign_key: "follower_id", dependent: :destroy
  has_many :coursefollows, through: :carts, source: :coursefollow
  has_many :registrations, foreign_key: "student_id", dependent: :destroy
  has_many :takenprogs, through: :registrations, source: :takenprog

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates(:name, presence: true, length: {maximum: 50} )
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false })
  validates(:password, presence: true, length: { minimum: 6 } )
  validates(:password_confirmation, presence: true)

  def classincart?(course)
    carts.find_by_coursefollow_id(course.id)
  end

  def putincart(course)
    carts.create!(coursefollow_id: course.id)
  end

  def removefromcart!(course)
    carts.find_by_coursefollow_id(course.id).destroy
  end

  def registered?(program)
    registrations.find_by_takenprog_id(program.id)
  end

  def register!(program)
    registrations.create!(takenprog_id: program.id)
  end

  def unregister!(program)
    registrations.find_by_takenprog_id(program.id).destroy
  end

  private

  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end
end
