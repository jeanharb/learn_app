class NotesController < ApplicationController
  before_filter :signed_in_user, except: [:view, :show]
  before_filter :course_creator, only: :create
  before_filter :note_creator, only: :destroy

  def create
    @course = Course.find(params[:note][:id])
    if params[:note].has_key?(:youtube)
      @link = params[:note][:content].match(/\/watch.*/)[0][9..-1]
      @note = @course.notes.build(:content => @link, :file_title => params[:note][:file_title], :filename => params[:note][:content], :contenttype => "youtube")
    else
      params[:note][:content].tempfile = Base64.encode64(open(params[:note][:content].tempfile).to_a.join)
      params[:note][:filename] = params[:note][:content].original_filename
      params[:note][:contenttype] = params[:note][:content].content_type
      @note = @course.notes.build(:content => params[:note][:content].tempfile, :file_title => params[:note][:file_title], :filename => params[:note][:filename], :contenttype => params[:note][:contenttype])
    end
    if @note.save
      redirect_to course_path(@course)
    else
      render root_path
    end
  end

  def view
    @note = Note.find(params[:id])
    @course = @note.course
    if @note.contenttype == "youtube"
      @url = "http://www.youtube.com/embed/" + @note.content
      @video = "yes"
    else
      @url = "http://docs.google.com/gview?url=http://learnocracy.herokuapp.com/notes/" + params[:id] + "&embedded=true"
      @video = "no"
    end
  end

  def show
    note = Note.find(params[:id])
    send_data note.as_file,
      :filename => note.filename,
      :type => note.contenttype,
      :disposition => "inline",
      :file_title => note.file_title
  end

  def download
    note = Note.find(params[:id])
    send_data note.as_file,
      :filename => note.filename,
      :type => note.contenttype
  end

  def destroy
    note = Note.find(params[:id])
    note.destroy
    redirect_to course_path(note.course_id)
  end

  private
    def note_creator
      redirect_to root_path unless des_note?
    end

    def course_creator
      redirect_to root_path unless note_creator?
    end
end