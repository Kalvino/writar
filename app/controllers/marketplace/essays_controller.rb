class Marketplace::EssaysController < ApplicationController
  before_action :authenticate_seller!

  layout "marketplace"

  def new
    authorize! :create, Essay
    @essay = Essay.new
    @active_section = :essays
  end

  def index
    @active_section = :essays
    respond_to do |format|
      format.html
      format.json { render json: EssaysDatatable.new(view_context) }
    end
  end

  def create
    authorize! :create, Essay
    @essay = current_seller.essays.create(essay_params)
    if @essay.save
      ThumbnailGeneratorWorker.perform_async(@essay.id)
      redirect_to marketplace_essays_path, notice: "Your paper was successfully uploaded."
    else
      render 'new'
    end
  end

  def show
    @essay = current_seller.essays.friendly.find(params[:id])
    authorize! :read, @essay
    @active_section = :essays
    if request.path != marketplace_essay_path(@essay)
      redirect_to [:marketplace, @essay], status: :moved_permanently
    end
  end

  def edit
    @essay = current_seller.essays.friendly.find(params[:id])
    authorize! :update, @essay
    @active_section = :essays
  end

  def update
    @essay = current_seller.essays.friendly.find(params[:id])
    authorize! :update, @essay

    if @essay.update(essay_params)
      redirect_to [:marketplace, @essay], notice: "Essay was successfully updated"
    else
      render 'edit'
    end
  end

  def pricing_guide
    @active_section = :essays
  end

  private

  def essay_params
    params.require(:essay).permit(:title,:price,:page_count,:word_count, :short_description, :question, :preview,
                                  :referencing_style_id, :category_id, :document)
  end
end
