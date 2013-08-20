class NotesController < ApplicationController
  before_filter :signed_in_user, except: [:view, :show]
  before_filter :course_creator, only: :create
  before_filter :note_creator, only: :destroy

  def create
    @course = Course.find(params[:note][:id])
    @error = 0
    @errors = []
    if params[:note].has_key?(:youtube)
      if !((params[:note][:content].include? "youtube") and (params[:note][:content].include? "/watch?v="))
        @errors << "Youtube link must be in 'youtube.com/watch?v=cmSbXsFE3l8' format."
        @error = 1
      end
      if params[:note][:file_title].length < 3
        @errors << "Video file title must be at least 3 characters long."
        @error = 1
      end
      if !@errors.any?
        @link = params[:note][:content].match(/\/watch.*/)[0][9..-1]
        @position = @course.notes.count
        @note = @course.notes.build(:position => @position,:content => @link, :file_title => params[:note][:file_title], :filename => params[:note][:content], :contenttype => "youtube")
      end
    else
      if params[:note][:file_title].length < 3
        @errors << "File title must be at least 3 characters long."
      end
      if !@errors.any?
        params[:note][:content].tempfile = Base64.encode64(open(params[:note][:content].tempfile).to_a.join)
        params[:note][:filename] = params[:note][:content].original_filename
        params[:note][:contenttype] = params[:note][:content].content_type
        @position = @course.notes.count
        @note = @course.notes.build(:position => @position, :content => params[:note][:content].tempfile, :file_title => params[:note][:file_title], :filename => params[:note][:filename], :contenttype => params[:note][:contenttype])
      end
    end
    if @errors.any?
      if @error == 1
        redirect_to notes_course_path(@course, :errors => @errors, :youtuber => "yes")
      else
        redirect_to notes_course_path(@course, :errors => @errors)
      end
    else
      if @note.save
        redirect_to notes_course_path(@course)
      else
        render root_path
      end
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

  def listorder_up
    @course = Course.find(params[:course])
    @note = Note.find(params[:id])
    @note.move_higher
    redirect_to notes_course_path(@course)
  end

  def listorder_down
    @course = Course.find(params[:course])
    @note = Note.find(params[:id])
    @note.move_lower
    redirect_to notes_course_path(@course)
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
    note.remove_from_list
    note.destroy
    if params.has_key?(:note_edit)
      redirect_to notes_course_path(note.course_id)
    else
      redirect_to course_path(note.course_id)
    end
  end

  private
    def note_creator
      redirect_to root_path unless des_note?
    end

    def course_creator
      redirect_to root_path unless note_creator?
    end
end