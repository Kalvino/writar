class Admin::FroalaUploadsController < ApplicationController
  before_action :authenticate_admin!

  def create
    # original name
    name = froala_upload_params[:file].original_filename

    # base directory
    directory = Rails.root.join("tmp").to_s

    # file type
    file_type = name.split('.').last
    # new name
    new_name = Digest::MD5.hexdigest(Time.now.to_i.to_s) + "." + file_type

    # create the file path
    file_path = File.join(directory, new_name)

    # write the file
    File.open(file_path, "wb") { |f| f.write(froala_upload_params[:file].read) }

    obj = $s3.bucket(ENV["S3_BUCKET_NAME"]).object("#{Rails.env}/froala/#{new_name}")
    obj.upload_file(file_path, { acl: 'public-read' })

    @upload = FroalaUpload.create(url: obj.public_url, name: new_name, file_size: File.size(file_path))

    # delete file
    File.delete(file_path)

    if @upload.save
      render json: { link: @upload.url }
    end
  end

  private

  def froala_upload_params
    params.require(:froala_upload).permit(:file)
  end
end
