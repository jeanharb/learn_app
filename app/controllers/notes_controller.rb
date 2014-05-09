class NotesController < ApplicationController
  before_filter :signed_in_user, except: [:view, :show]
  before_filter :course_creator, only: :create
  before_filter :note_creator, only: [:destroy, :listorder_up, :listorder_down]

  def create
    @course = Course.find(params[:note][:id])
    @error = 0
    @errors = []
    @position = @course.notes.count
    if params[:note].has_key?(:youtube)
        @link = params[:note][:content].match(/\/watch.*/)[0][9..-1]
        @note = @course.notes.build(:position => @position,:content => @link, :file_title => params[:note][:file_title], :filename => params[:note][:content], :contenttype => "youtube")
    else
        params[:note][:content].tempfile = Base64.encode64(open(params[:note][:content].tempfile).to_a.join)
        params[:note][:filename] = params[:note][:content].original_filename
        params[:note][:contenttype] = params[:note][:content].content_type
        @note = @course.notes.build(:position => @position, :content => params[:note][:content].tempfile, :file_title => params[:note][:file_title], :filename => params[:note][:filename], :contenttype => params[:note][:contenttype])
    end
    if @errors.any?
      if @error == 1
        redirect_to edit_course_path(@course, :errors => @errors, :youtuber => "yes")
      else
        redirect_to edit_course_path(@course, :errors => @errors)
      end
    else
      if @note.save
        @notes = @course.notes #Have to fix this
        render :template => "notes/new_notes_j", :locals => {:@new_note => @course.notes.build, :@notes => @notes, :@course_id => @course.id, :@course => @course}
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

  def update
    @note = Note.find(params[:id])
    @course_id = @note.course_id
    @course = Course.find(@course_id)
    @notes = @course.notes
    if(params.has_key?(:note))
      @move = params[:note][:move]
      if(@move=="0")
        @note.move_lower
      else
        @note.move_higher
      end
      render :template => "notes/destroy_js", :locals => {:@notes => @notes, :@course_id => @course_id}
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
    @course = Course.find(note.course_id)
    note.remove_from_list
    if note.destroy
      @notes = @course.notes
      @course_id = @course.id
      render :template => "notes/destroy_js", :locals => {:@notes => @notes, :@course_id => @course_id}
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