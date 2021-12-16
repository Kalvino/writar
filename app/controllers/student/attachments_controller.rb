class Student::AttachmentsController < ApplicationController
  before_action :authenticate_student!

  def download
    @attachment = Attachment.find(params[:attachment_id])
    Attachment.increment_counter(:downloads, @attachment.id)
    file = open(@attachment.file.url).read
    send_data file, filename: @attachment.file_file_name, type: @attachment.file_content_type, disposition: 'attachment'
  end
end
