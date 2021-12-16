class Admin::WritersController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  add_breadcrumb "Dashboard", :admin_dashboard_path


  def index
    authorize! :read, Writer

    @writers = Writer.all
    @active_section = :writers

    add_breadcrumb "Writers", :admin_writers_path
  end

  def new
    authorize! :create, Writer

    @writer = Writer.new
    @active_section = :writers

    add_breadcrumb "writers", :admin_writers_path
    add_breadcrumb "New", :new_admin_writer_path
  end

  def create
    @writer = Writer.new(writer_params)
    @writer.password = "p@ssw0rd"
    if @writer.save
      redirect_to admin_writers_path, notice: "Writer successfully added"
    else
      render :new
    end
  end

  def show
    @writer = Writer.friendly.find(params[:id])
    authorize! :read, @writer
    @orders = @writer.orders

    add_breadcrumb "Writers", :admin_writers_path
    add_breadcrumb @writer.name, admin_writer_path(@writer)
  end

  def edit
    @writer = Writer.friendly.find(params[:id])
    authorize! :update, @writer

    add_breadcrumb "Writers", :admin_writers_path
    add_breadcrumb @writer.name, admin_writer_path(@writer)
    add_breadcrumb "Edit", edit_admin_writer_path(@writer)
  end


  def update
    @writer = Writer.friendly.find(params[:id])
    authorize! :update, @writer

    if @writer.update(writer_params)
      redirect_to [:admin, @writer], notice: "Writer profile successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @writer = Writer.friendly.find(params[:id])
    authorize! :destroy, @writer

    @writer.destroy
    redirect_to admin_writers_path, notice: "Writer successfully deleted"
  end

  private

  def writer_params
    params.require(:writer).permit(:first_name,:last_name,:phone,:email,:rate_per_page)
  end
end
