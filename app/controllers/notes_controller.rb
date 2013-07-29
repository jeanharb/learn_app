class NotesController < ApplicationController
  before_filter :signed_in_user
  before_filter :course_creator, only: [:create, :destroy]

  def create
    @course = Course.find(params[:note][:id])
    params[:note][:content].tempfile = Base64.encode64(open(params[:note][:content].tempfile).to_a.join)
    params[:note][:filename] = params[:note][:content].original_filename
    params[:note][:contenttype] = params[:note][:content].content_type
    @note = @course.notes.build(:content => params[:note][:content].tempfile, :filename => params[:note][:filename], :contenttype => params[:note][:contenttype])
        if @note.save
          flash[:success] = "File Uploaded!"
          redirect_to course_path(@course)
        else
          render root_path
        end
  end

  def download
    note = Note.find(params[:id])
    send_data note.as_file,
      :filename => note.filename,
      :type => note.contenttype
  end

  def destroy
  end

  private
    def course_creator
      redirect_to root_path unless note_creator?
    end
end