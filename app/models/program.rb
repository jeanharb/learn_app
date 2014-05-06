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
    @allpre = @relationships
    @allrela = @program.relationships
    @allprer = []
    @nothingcourse = []
    @bottomcourse = []
    @topcourse = []
    @middlecourse = []
    @passedcourses = []
    @relation = []
    @connections = {}
    @relationships.each do |rel|
      @relation << [rel.want_id, rel.required_id, rel.id]
      if @connections[rel.want_id] == nil
        @connections[rel.want_id] = 1
      else
        @connections[rel.want_id] += 1
      end
      if @connections[rel.required_id] == nil
        @connections[rel.required_id] = 1
      else
        @connections[rel.required_id] += 1
      end
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

    #### HERE

    @coursewidths = {}
    @levelcourses = {}
    @courselevels.each do |course, h|
      if @coursewidths.has_key?(h)
        @coursewidths[h]+=1
      else
        @coursewidths[h]=1
      end
      if @levelcourses.has_key?(h)
        @levelcourses[h] << course.id
      else
        @levelcourses[h] = [course.id]
      end
    end
    @maxwidth = 0
    @coursewidths[40]=0
    @coursewidths.each do |h, value|
      @coursewidths[h]-=1
      if value>@maxwidth
        @maxwidth = value
      end
    end

    @levelcourses.delete(40)
    @aaa = 0
    @optimal = {}
    @posi = {}
    @min = 100000

    def ww(a)
      @c2 = {}
      @levelcourses.each do |key, arr|
        @a = (@maxwidth-arr.length)/2
        arr.each do |cour|
          @c2[cour] = [key, @a+a[cour][1]]
        end
      end
      return @c2
    end

    def dis(a)
      @qqq = 0
      @c1 = ww(a)
      @allpre.each do |pre|
        first = pre.required_id
        sec = pre.want_id
        @qqq += (((@c1[first][0]-@c1[sec][0])**2)+((@c1[first][1]-@c1[sec][1])**2))**0.5
      end
      return @qqq
    end
    def dista (levels, row, col, c, p)
      if @min > 55
          if (row<levels.length-1)
            if (col<levels[row].length)
              @tem = c.clone
              c.each do |num|
                @tem.delete(num)
                @tem1 = p.clone
                @tem1[levels[row][col]] = [row, num]
              dista(levels, row, col+1, @tem, @tem1)
                @tem = c.clone
              end
              else
                @ar1 = []
              for i in 0..@levelcourses[row+1].length-1
              @ar1 << i
            end
                dista(levels, row+1, 0, @ar1, p)
              end
            else
              if (col<levels[row].length)
              @tem = c.clone
              c.each do |num|
                @tem.delete(num)
                @tem1 = p.clone
                @tem1[levels[row][col]] = [row, num]
              dista(levels, row, col+1, @tem, @tem1)
                @tem = c.clone
              end
              else
                @zz = dis(p)
                if @zz < @min
                  @min = @zz
                  @optimal = p.clone
                end
              end
          end
        end
      end

      @min1 = 10000

      def neighbors (levels, current, p)
        levels.each do |ll, l|
          if l.length != 1
            l.each do |l1|
              if Random.rand(@connections[l1]) >= 2
                l.each do |l2|
                  if l2>l1
                    @temp1 = p.clone
                    @temp2 = @temp1[l1].clone
                    @temp1[l1] = @temp1[l2].clone
                    @temp1[l2] = @temp2.clone
                    @a1 = dis(@temp1)
                    if @a1 < current
                      if @min > @a1
                        @min = @a1
                        @optimal = @temp1.clone
                      end
                      neighbors(levels, @a1, @temp1)
                    end
                  end
                end
              end
            end
          end
        end
      end
    @ar = []

    if(!(@levelcourses.length == 0))
      for i in 0..@levelcourses[0].length-1
        @ar << i
      end
      dista(@levelcourses, 0, 0, @ar, @posi)
    end
    neighbors(@levelcourses, @min, @optimal)
    @optimal.each do |k, v|
      @rela = @allrela.find_by_course_id(k)
      @rela.prereqpos = v[1]
      @rela.prereqlevel = v[0]
      @rela.save
    end
  end
end
