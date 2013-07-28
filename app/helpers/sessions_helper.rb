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

	def is_admin?
		current_user.admin?
	end

	def creator?
		current_user?(User.find(Course.find(params[:id]).user_id))
	end

	def current_user?(user)
		user == current_user
	end

	def current_user=(user)
		@current_user = user
	end

	def coursefile(note)
		File.open(note.filename, 'wb') do |f|
        f.write(Base64.decode64(note.content))
    end
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

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end
	
	def store_location
		session[:return_to] = request.url
	end
end
