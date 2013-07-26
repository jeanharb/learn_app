class NotesController < ApplicationController
  before_filter :signed_in_user
  
  def new
    @user = User.find_by_remember_token(cookies[:remember_token])
    @notes = @user.notes
    @note = current_user.notes.build if signed_in?
  end

  def create
       if (params[:note][:content].blank? || params[:note].blank? || params[:note][:content].tempfile.blank?)
        flash[:error] = 'Fields cannot be blank.'
        redirect_to root_path
      else
        params[:note][:content].tempfile = Base64.encode64(open(params[:note][:content].tempfile).to_a.join)
        params[:note][:filename] = params[:note][:content].original_filename
        @note = current_user.notes.build(params[:note])
        if @note.save
          flash[:success] = "File Uploaded!"
          redirect_to files_path
        else
          render files_path
        end
      end
  end

  def destroy
  end
end