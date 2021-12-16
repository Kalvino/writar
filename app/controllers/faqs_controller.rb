class FaqsController < ApplicationController
  def index
    @faqs = Faq.order("created_at ASC")

    add_breadcrumb "FAQs", :faqs_path
  end
end
