module SessionsHelper
	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

	def signed_in_user
		unless signed_in?
			store_location
			redirect_to signin_url
		end
	end

	def setprereqcolor(cour)
		@rela = Relationship.where("course_id = ?", cour.id)
		@rela.each do |change|
			change.prereqcolor = "green"
			change.save
		end
	end

	def countpassedcourse(course)
		@num = Completecourse.where("course_id = ?", course.id).where("passed = ?", "true")
		if !@num.nil?
			@num = @num.count
			@course = Course.find(course.id)
			@course.numstudentspass = @num
			@course.save
		end
	end

	def countpassedprog(prog)
		@num = Completeprogram.where("program_id = ?", prog.id).where("progress = ?", 100)
		if !@num.nil?
			@num = @num.count
			@program = Program.find(prog.id)
			@program.numstudentspass = @num
			@program.save
		end
	end

	def countcoursestudents(course)
	    @num = Courseregistration.where("takencourse_id = ?", course.id)
	    if !@num.nil?
	    	@num = @num.count
	    	@course = Course.find(course.id)
		    @course.numstudents = @num
		    @course.save
	    end
	  end

	  def countprogstudents(prog)
	    @num = Registration.where("takenprog_id = ?", prog.id)
	    if !@num.nil?
	    	@num = @num.count
	    else
	    	@num = 0
	    end
	    @prog = Program.find(prog.id)
	    @prog.numstudents = @num
	    @prog.save
	  end

	def is_admin?
		current_user.admin?
	end

	def current_user?(user)
		user == current_user
	end

	def current_user=(user)
		@current_user = user
	end

	def num_notes(user)
		@courses = user.courses
		@num_notes = 0
		@courses.each do |course|
			@num_notes += course.notes.count
		end
		@num_notes
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def find_course_title(course)
		Course.find(course).title
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end
	
	def store_location
		session[:return_to] = request.url
	end

	private
		def registered_in?
			first = current_user.courseregistered?(Course.find(Exam.find(params[:id]).course_id))
			second = false
			if params.has_key?(:program)
				second = current_user.registered?(Program.find(params[:program]))
			end
			first or second
		end

		def creator?
			current_user?(User.find(Course.find(params[:id]).user_id)) || is_admin?
		end

		def examcreator?
			current_user?(User.find(Course.find(params[:id]).user_id))
		end

		def destroyer?
			current_user?(User.find(Course.find(Exam.find(params[:id]).course_id).user_id))
		end

		def progcreator?
			current_user?(User.find(Program.find(params[:id]).user_id)) || is_admin?
		end

		def progcreate
			current_user?(User.find(Program.find(params[:id]).user_id))
		end

		def courcreator
			current_user?(User.find(Course.find(params[:id]).user_id))
		end

		def courcreator?(course)
			current_user?(User.find(course.user_id))
		end

		def des_note?
			current_user?(User.find(Course.find(Note.find(params[:id]).course_id).user_id)) || is_admin?
		end

		def note_creator?
			current_user?(User.find(Course.find(params[:note][:id]).user_id))
		end
end
