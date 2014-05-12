class ProgramsController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user, only: [:edit, :update, :destroycourse]
	before_filter :correct_user_add, only: :addcourses
	before_filter :program_des, only: :destroy

	def new
		@user = User.find_by_remember_token(cookies[:remember_token])
    	@program = current_user.programs.build if signed_in?
	end

	def create
        @program = current_user.programs.build(params[:program])
        if @program.save
          countcat(params[:program][:category])
          redirect_to program_path(@program)
        else
          render 'new'
        end
	end

	def prereq_tree
		require 'json'
		@program = Program.find(params[:id])
		@allrela = @program.relationships
		@allpre = @program.prerequisites
		@courses = @program.courses
		@courselevels = {}
		@nothingcourse = []
		@doneunder = []
		@passedcourses = []
		@coursestop = {}
		@coursesbottom = {}
		@relation = []
		@connections = {}
		@allrela.each do |rel|
			@courselevels[Course.find(rel.course_id)] = rel.prereqlevel
			if rel.prereqlevel == 40
				@nothingcourse << Course.find(rel.course_id)
			end
		end
		@allpre.each do |pre|
			if @coursestop[pre.required_id].nil?
				@coursestop[pre.required_id] = [pre.want_id]
			else
				@coursestop[pre.required_id] << pre.want_id
			end
			if @coursesbottom[pre.want_id].nil?
				@coursesbottom[pre.want_id] = [pre.required_id]
			else
				@coursesbottom[pre.want_id] << pre.required_id
			end
			@relation << [pre.want_id, pre.required_id]
			if @connections[pre.want_id] == nil
				@connections[pre.want_id] = 1
			else
				@connections[pre.want_id] += 1
			end
			if @connections[pre.required_id] == nil
				@connections[pre.required_id] = 1
			else
				@connections[pre.required_id] += 1
			end
		end
		@courses.each do |course|
	        if current_user.passedcourse?(current_user, course)
	        	@passedcourses << course.id
	        end
	    end
		@courses.each do |course|
	        if !@passedcourses.include?(course.id)
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
	        	if @coursewant.count > 0
		        	@howmany = 0
		        	@coursewant.each do |prer|
		        	    if @passedcourses.include?(prer)
		        	    	@howmany += 1
		        	    end
		        	end
		        	if @howmany == @coursewant.count
		        	    @doneunder << course.id
		        	end
		    	else
		    		@doneunder << course.id
		    	end
		    end
	    end
		@highestlevel = 0
		@courselevels.each do |key, value|
			if value > @highestlevel and value != 40
				@highestlevel = value
			end
		end
		@allprereqs = []
		@courses.each do |course|
			@coursewant = []
			@relation.each do |rel|
				if rel[0] == course.id
					@coursewant << rel[1]
				end
			end
			@coursewant.each do |prer|
				@first = "#" + course.id.to_s
				@second = "#" + prer.to_s
				@allprereqs << [@first, @second]
			end
		end

		@levelcourses = {}
		@optimal = {}
		@courselevels.each do |course, h|
			if @levelcourses.has_key?(h)
				@levelcourses[h] << course.id
			else
				@levelcourses[h] = [course.id]
			end
			@temp11 = Relationship.find_by_program_id_and_course_id(@program.id, course.id)
			@optimal[course.id] = [@temp11.prereqlevel, @temp11.prereqpos]
		end

		@layers = []
		@lays = []
		puts "HEHEHHHHHH"
		puts @highestlevel
		puts @levelcourses
		
		if (!(@highestlevel==0))
			for i in 0..@highestlevel do
				for j in 0..@levelcourses[i].length-1 do
					if @layers[i] == nil
						@layers[i] = [Course.find(@optimal.invert[[i,j]])]
					else
						@layers[i] << Course.find(@optimal.invert[[i,j]])
					end
				end
				@lays << (@highestlevel-i)
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
		@total_course = 0
		@cours_items.each do |course|
			@status = Completecourse.find_by_course_id_and_user_id(course.id, current_user.id)
			if !@status.nil?
				if @status.passed
					@total_course += 1
				end
			end
		end
		if !@cours_items.nil?
			if @cours_items.count > 0
				@progress = ((@total_course.to_f/@cours_items.count.to_f)*100).round
				@progress_width = 100-@progress
			end
		end
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
			countcat(params[:program][:category])
			render "program_edit_js"
		else
			render "program_edit_js"
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

	def destroycourse
		@program = Program.find(params[:course][:program])
		@course = Course.find(params[:course][:course])
		@courses = @program.courses
		@program.removeclass!(@course)
		render :template => "programs/course_move_js", :locals => {:@courses => @courses}
	end

	def destroy
		@program = Program.find(params[:id])
		@program.destroy
		redirect_to '/creations'
	end

	private

		def countcat(cat)
			@num = Program.where("category = ?", cat)
			@count = @num.count
			@cat = Category.find(cat)
			@cat.numprog = @count
			@cat.save
		end

		def program_des
			redirect_to root_path unless progcreator?
		end

		def is_admin
			redirect_to root_path unless is_admin?
		end

		def signed_in_user
			redirect_to root_path, notice: "Please sign in." unless signed_in?
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