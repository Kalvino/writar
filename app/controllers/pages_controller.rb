class PagesController < ApplicationController
  def show
    add_breadcrumb "Pages", "#"
    @page = Page.friendly.find(params[:id])
    add_breadcrumb @page.name, page_path(@page)
  end
end
