class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :creator
  has_secure_password
  has_many :courses, dependent: :destroy
  has_many :programs, dependent: :destroy
  has_many :carts, foreign_key: "follower_id", dependent: :destroy
  has_many :coursefollows, through: :carts, source: :coursefollow
  has_many :registrations, foreign_key: "student_id", dependent: :destroy
  has_many :takenprogs, through: :registrations, source: :takenprog
  has_many :courseregistrations, foreign_key: "courstudent_id", dependent: :destroy
  has_many :takencourses, through: :courseregistrations, source: :takencourse
  has_many :examresults, dependent: :destroy
  has_many :courseratings, dependent: :destroy
  has_many :programratings, dependent: :destroy
  has_many :completecourses, dependent: :destroy
  has_many :completeprograms, dependent: :destroy

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates(:name, presence: true, length: {maximum: 50} )
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false })
  validates(:password, presence: true, length: { minimum: 6 } )
  validates(:password_confirmation, presence: true)

  def createprogramrating!(program, rating)
    courseratings.create!(course_id: program.id, rating: rating)
  end

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

  def courseregistered?(course)
    courseregistrations.find_by_takencourse_id(course.id)
  end

  def courseregister!(course)
    courseregistrations.create!(takencourse_id: course.id)
  end

  def courseunregister!(course)
    courseregistrations.find_by_takencourse_id(course.id).destroy
  end

  def finishcourse!(course)
    completecourses.create!(course_id: course.id, passed: "true")
  end

  def failedcourse!(course)
    completecourses.create!(course_id: course.id, passed: "false")
  end

  def passedcourse?(user, course)
    ispassed = Completecourse.where("user_id = ?", user.id).where("course_id = ?", course.id)
    if ispassed.exists?
      if completecourses.find_by_course_id(course).passed == "true"
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def countprogressprog(prog, user)
    @program = Program.find(prog.id)
    @count = @program.courses.count
    @counting = 0
    if @count > 0
      @program.courses.each do |course|
        @cour = Completecourse.find_by_course_id_and_user_id(course.id, user.id)
        if !@cour.nil?
          if @cour.passed == "true"
            @counting += 1
          end
        end
      end
      @progress = ((@counting.to_f/@count.to_f)*100).round
    else
      @progress = 0
    end
    completeprograms.create!(program_id: prog.id, progress: @progress)
  end

  private

  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end
end
