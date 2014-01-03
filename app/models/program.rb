class Program < ActiveRecord::Base
  attr_accessible :short_desc, :description, :title, :average_rating, :num_rating, :rating_algo, :category
  belongs_to :user
  has_many :relationships, foreign_key: "program_id", dependent: :destroy
  has_many :courses, order: :position, through: :relationships, source: :course
  has_many :wants, through: :prerequisites, source: :want
  has_many :required_courses, through: :prerequisites, source: :required
  has_many :prerequisites, foreign_key: "wantpro_id", dependent: :destroy
  has_many :students, through: :reverse_registrations, source: :student
  has_many :reverse_registrations, foreign_key: "takenprog_id", class_name: "Registration", dependent: :destroy
  has_many :programratings, dependent: :destroy
  has_many :ratings, through: :programratings, source: :program
  has_many :review_titles, through: :programratings, source: :program
  has_many :review_contents, through: :programratings, source: :program
  has_many :completeprograms, dependent: :destroy

  validates :user_id, presence: true
  validates :description, presence: true
  validates :title, presence: true
  validates :short_desc, presence: true, length: { maximum: 300 }
  validates :average_rating, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 5}
  validates :rating_algo, :numericality => {:integer => true}

  def makeprerequisite!(course1, course2)
    prerequisites.create!(required_id: course2.id, want_id: course1.id)
  end

  def hasrating?(user)
    programratings.find_by_user_id(user.id)
  end

  def createrating!(user, rating)
    programratings.create!(user_id: user.id, rating: rating)
  end

  def isprerequisite?(course1, course2)
    prerequisites.find_by_required_id_and_want_id(course2.id, course1.id)
  end

  def removeprerequisite!(course1, course2)
    prerequisites.find_by_required_id_and_want_id(course2.id, course1.id).destroy
  end

  def takingclass?(course)
    relationships.find_by_course_id(course.id)
  end

  def takeclass!(course)
    relationships.create!(course_id: course.id, prereqlevel: 40)
  end

  def removeclass!(course)
    relationships.find_by_course_id(course.id).destroy
  end

  def setup_prereqs
    require 'json'
    @program = self
    @courses = @program.courses
    @relationships = @program.prerequisites
    @allrela = @program.relationships
    @allprer = []
    @nothingcourse = []
    @bottomcourse = []
    @topcourse = []
    @middlecourse = []
    @passedcourses = []
    @relation = []
    @relationships.each do |rel|
      @relation << [rel.want_id, rel.required_id, rel.id]
    end
    @courses.each do |course|
      @coursewant = []
      @courseneeded = []
      @relation.each do |rel|
        if rel[0] == course.id
          @coursewant << rel[1]
        end
        if rel[1] == course.id
          @courseneeded << rel[0]
        end
      end
      if @coursewant.count == 0
        if @courseneeded.count > 0
          @bottomcourse << course
        else
          @nothingcourse << course
        end
      end
      @coursewant.each do |prer|
        @course_pre = Course.find(prer)
        @allprer << [course, @course_pre]
      end
    end
    @courselevels = {}
    @coursele = {}
    def findlevels(bottom, number)
      bottom.each do |a|
        @level = number
        if @courselevels[a].nil? or @courselevels[a] < @level
          @courselevels.merge!(a => @level)
          @coursele.merge!(a.id => @level)
        end
        @under = Prerequisite.where("required_id = ?", a.id).where("wantpro_id = ?", @program.id)
        @underarray = []
        @under.each do |prereq|
          @underarray << Course.find(prereq.want_id)
        end
        findlevels(@underarray, @level+1)
      end
    end
    findlevels(@bottomcourse, 0)
    def findtoplevel(pre)
      @lowest = 40
      @allprer.each do |each|
        @eee = each[0]
        if each[1].id == pre.id
          if (@coursele[@eee.id] - 1) < @lowest
            @lowest = @coursele[@eee.id] - 1
          end
        end
      end
      if @lowest != 40
        @courselevels[pre] = @lowest
      end
    end
    @bottomcourse.each do |prelev|
      findtoplevel(prelev)
    end
    @middlecourse.each do |prelev|
      findtoplevel(prelev)
    end
    @nothingcourse.each do |course|
      @rela = @allrela.find_by_course_id(course.id)
      @rela.prereqlevel = 40
      @rela.save
    end
    @courselevels.each do |course, level|
      @rela = @allrela.find_by_course_id(course.id)
      @rela.prereqlevel = level
      @rela.save
    end
  end
end
