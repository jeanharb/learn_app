class ProgramsController < ApplicationController
	before_filter :signed_in_user, only: [:create, :edit, :update]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :correct_user_add, only: :addcourses
	before_filter :program_des, only: :destroy

	def new
		@user = User.find_by_remember_token(cookies[:remember_token])
    	@program = current_user.programs.build if signed_in?
	end

	def create
        @program = current_user.programs.build(params[:program])
        if @program.save
          redirect_to program_path(@program)
        else
          render 'new'
        end
	end

	def prereq_tree
		@program = Program.find(params[:id])
		@courses = @program.courses
		@nothingcourse = []
		@bottomcourse = []
		@topcourse = []
		@middlecourse = []
		@courselevels = {}
		@courses.each do |course|
			@coursewant = Prerequisite.where("want_id = ?", course.id).where("wantpro_id = ?", @program.id)
			@courseneeded = Prerequisite.where("required_id = ?", course.id).where("wantpro_id = ?", @program.id)
			if @courseneeded.exists?
				if @coursewant.exists?
					@middlecourse << course
				else
					@bottomcourse << course
				end
			else
				if @coursewant.exists?
					@topcourse << [course, []]
				else
					@nothingcourse << course
				end
			end
		end
		@courselevels = {}
		def findlevels(bottom, number)
			bottom.each do |a|
				@level = number
				if @courselevels[a].nil?
					@courselevels.merge!(a => @level)
				elsif @courselevels[a] < @level
					@courselevels.merge!(a => @level)
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
		@highestlevel = 0
		@courselevels.each do |key, value|
			if value > @highestlevel
				@highestlevel = value
			end
		end
	end

	def index
		@programs = Program.order("rating_algo DESC").all
	end

	def prerequisites
		@program = Program.find(params[:id])
		@course = @program.courses.all
	end

	def removeprerequisites
		@program = Program.find(params[:id])
		@course = @program.courses.all
	end

	def show
		@program = Program.find(params[:id])
		@rating = Programrating.new
		@review = Programrating.new
		@cours_items = @program.courses.all
		@hasreview = Programrating.where("program_id = ?", @program.id).where("user_id = ?", current_user.id).where("review_title IS NOT NULL")
		@programratings = Programrating.where("program_id = ?", @program.id).where("rating IS NOT NULL")
		@programreviews = Programrating.where("program_id = ?", @program.id).where("review_title IS NOT NULL")
		@averagerating = "0"
		if @programratings.any?
			if @program.average_rating != 0
				@num_rates = @program.num_rating
				@averagerating = @program.average_rating
				@good_starwidth = (@averagerating.to_f/0.05).to_f.to_s + "%"
				@anti_starwidth = (((1-(@averagerating.to_f/5))*100).to_f).to_f.to_s + "%"
			end
		end
	end

	def edit
		@program = Program.find(params[:id])
		@courses = @program.courses
	end

	def update
		@program = Program.find(params[:id])
		if @program.update_attributes(params[:program])
			redirect_to program_path(@program)
		else
			render 'edit'
		end
	end

	def addcourses
		if !params.has_key?(:program)
			redirect_to "/creations"
		elsif params[:program].nil?
			redirect_to "/creations"
		end
		@courses = Course.all
		@carts = Cart.where("follower_id = ?", current_user.id)
		@program = Program.find(params[:program])
	end

	def destroy
		@program = Program.find(params[:id])
		@program.destroy
		redirect_to '/creations'
	end

	private

		def program_des
			redirect_to root_path unless progcreator?
		end

		def is_admin
			redirect_to root_path unless is_admin?
		end

		def signed_in_user
			redirect_to signin_url, notice: "Please sign in." unless signed_in?
		end

		def correct_user_add
			@user = User.find(Program.find(params[:program]).user_id)
			redirect_to(root_path) unless current_user?(@user)
		end

		def correct_user
			@user = User.find(Program.find(params[:id]).user_id)
			redirect_to(root_path) unless current_user?(@user)
		end
end