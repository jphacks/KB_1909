module V1
  class ImagesController < ApplicationController
    require 'securerandom'

    def create
      image = Image.new
      image.post_id = params[:post_id]
      uploaded_file = params[:file]
      image.name = "#{SecureRandom.base58(20)}@#{uploaded_file.original_filename.gsub(" ", "")}"
      output_path = Rails.root.join('public/images', image.name)
      image.image = "images/"+image.name
      File.open(output_path, 'w+b') do |fp|
        fp.write  uploaded_file.read
      end
      if image.save!
        render json: image
      else
        render json: image.errors, status: :unprocessable_entity
      end
    end


    def show
      @image = Image.find_by(post_id: params[:post_id])
    end

  end
end

