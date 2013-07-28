class NotesController < ApplicationController
  before_filter :signed_in_user

  def create
    @course = Course.find(params[:note][:id])
    params[:note][:content].tempfile = Base64.encode64(open(params[:note][:content].tempfile).to_a.join)
    params[:note][:filename] = params[:note][:content].original_filename
    @note = @course.notes.build(params[:note])
        if @note.save
          flash[:success] = "File Uploaded!"
          redirect_to course_path(@course)
        else
          render root_path
        end
  end

  def destroy
  end
end