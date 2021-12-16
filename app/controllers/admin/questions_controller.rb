class Admin::QuestionsController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Admin", :admin_dashboard_path
  add_breadcrumb "Questions", :admin_questions_path

  def index
    authorize! :read, Question

    @questions_today = Question.today.count
    @questions_this_week = Question.this_week.count
    @questions_this_month = Question.this_month.count
    @questions_this_year = Question.this_year.count

    @active_section = :questions
    @current_action = :index

    respond_to do |format|
      format.html
      format.json { render json: QuestionsDatatable.new(view_context) }
    end
  end

  def new
    add_breadcrumb "New", :new_admin_question_path

    authorize! :create, Question

    @question = Question.new
    @active_section = :questions
    @current_action = :new
  end

  def create
    authorize! :create, Question

    @question = Question.create(question_params)
    if @question.save
      redirect_to [:admin, @question], notice: "Question was successfully saved"
    else
      render 'new'
    end
  end

  def show
    @question = Question.friendly.find(params[:id])
    authorize! :read, @question

    add_breadcrumb "##{@question.id}", [:admin,@question]
  end


  def edit
    @question = Question.friendly.find(params[:id])
    authorize! :update, @question

    add_breadcrumb "##{@question.id}", [:admin,@question]
    add_breadcrumb "Edit", edit_admin_question_path(@question)
  end

  def update
    @question = Question.friendly.find(params[:id])
    authorize! :update, @question

    @question.admin_id = current_admin.id

    if @question.update(question_params)
      respond_to do |format|
        format.json { render json: { message: "This question has been successfully marked as: #{@question.status}"  }}
        format.html { redirect_to [:admin, @question], notice: "Question successfully updated" }
      end
    else
      render "edit"
    end
  end

  def destroy
    @question = Question.friendly.find(params[:id])
    authorize! :destroy, @question

    @question.destroy
    redirect_to admin_questions_path, notice: "Question successfully deleted"
  end

  def import
    GoogleSheetsWorker.perform_async
    redirect_to admin_questions_path, notice: "Google sheets questions import started in background"
  end

  def remove_duplicates
    DuplicatesWorker.perform_async
    redirect_to admin_questions_path, notice: "Duplicates deletion started in background"
  end

  private

  def question_params
    params.require(:question).permit(:title, :content, :status)
  end
end
