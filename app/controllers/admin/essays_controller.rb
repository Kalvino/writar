class Admin::EssaysController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Admin", :admin_dashboard_path

  def index
    authorize! :read, Essay

    add_breadcrumb "Papers", :admin_essays_path
    @papers_today = Essay.today.count
    @papers_this_week = Essay.this_week.count
    @papers_this_month = Essay.this_month.count
    @papers_this_year = Essay.this_year.count
    @active_section = :essays
    @current_action = :index
    respond_to do |format|
      format.html
      format.json { render json: EssaysDatatable.new(view_context) }
    end
  end

  def new
    authorize! :create, Essay

    @essay = Essay.new

    @active_section = :essays
    @current_action = :new

    add_breadcrumb "Papers", :admin_essays_path
    add_breadcrumb "New", :new_admin_essay_path
  end

  def create
    authorize! :create, Essay
    @essay = current_admin.essays.new(essay_params) #.merge({ approved: true })
    @essay.current_user_type = "Admin"
    if @essay.save
      ThumbnailGeneratorWorker.perform_async(@essay.id)
      redirect_to admin_essays_path, notice: "Essay was successfully saved"
    else
      render 'new'
    end
  end

  def show
    @essay = Essay.friendly.find(params[:id])
    authorize! :read, @essay

    @active_section = :essays
    @current_action = :show

    add_breadcrumb "Papers", :admin_essays_path
    add_breadcrumb @essay.title, [:admin, @essay]
  end

  def edit
    @essay = Essay.friendly.find(params[:id])
    authorize! :update, @essay

    @active_section = :essays
    @current_action = :edit

    add_breadcrumb "Papers", :admin_essays_path
    add_breadcrumb @essay.title, [:admin, @essay]
    add_breadcrumb "Edit", edit_admin_essay_path(@essay)
  end

  def update
    @essay = Essay.friendly.find(params[:id])
    authorize! :update, @essay
    essay_params[:status].present? ?  @essay.current_user_type = "Seller" : @essay.current_user_type = "Admin"

    if @essay.update(essay_params)
      if @essay.approved? && @essay.owner_type != "Admin" && essay_params[:status].present?
        NotificationMailer.delay.approved_paper(@essay)
      end

      respond_to do |format|
        format.json { render json: { message: "This paper has been successfully marked as #{@essay.status}"  }}
        format.html { redirect_to [:admin, @essay], notice: "Essay was successfully updated" }
      end
    else
      render 'edit'
    end
  end

  def destroy
    @essay = Essay.friendly.find(params[:id])
    authorize! :destroy, @essay
  end

  def refresh_thumbnails
    @essay = Essay.friendly.find(params[:essay_id])
    authorize! :refresh_thumbnails, @essay

    ThumbnailGeneratorWorker.perform_async(@essay.id, true)
    render json: { status: "queued" }
  end

  private

  def essay_params
    params.require(:essay).permit(:title,:price,:page_count,:word_count, :short_description, :question, :status,
                                  :preview, :referencing_style_id, :category_id, :document)
  end
end
