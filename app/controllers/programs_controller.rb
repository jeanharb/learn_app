class ProgramsController < ApplicationController
	before_filter :signed_in_user, only: [:create, :edit, :update]
	before_filter :correct_user, only: [:edit, :update]
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

	def index
		@programs = Program.all
	end

	def show
		@program = Program.find(params[:id])
		@cours_items = @program.courses.all
	end

	def edit
		@program = Program.find(params[:id])
	end

	def update
		@program = Program.find(params[:id])
		if @program.update_attributes(params[:program])
			redirect_to program_path(@program)
		else
			render 'edit'
		end
	end

	def destroy
		@program = Program.find(params[:id])
		@program.destroy
		redirect_back_or creations_path
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

		def correct_user
			@user = User.find(Program.find(params[:id]).user_id)
			redirect_to(root_path) unless current_user?(@user)
		end
end