module V2
  class PostsController < ApplicationController
    require 'time'
    before_action :authenticate!, only: [:good, :create]

    # GET /posts
    def index
      lat = params[:latitude].to_f
      lng = params[:longitude].to_f
      delta = params[:delta].to_f
      delta = 0.0001 if delta < 0.000001 || delta > 3
      p delta
      @posts = Post.where("(latitude > ?) AND (latitude < ?) AND (longitude > ?) AND (longitude < ?)",
                 lat-delta, lat+delta, lng-delta, lng+delta)
      @json_posts = @posts.map do |post|
        json_post = {}
        json_post[:id] = post.id
        json_post[:body] = post.body
        json_post[:url] = post.url
        json_post[:distance] = distance(lat, lng, post.latitude, post.longitude)
        json_post[:created_at] = post.created_at.to_i
        json_post[:latitude] = lat
        json_post[:longitude] = lng
        json_post[:user_id] = post&.user_id
        json_post[:good] = GoodPost.where(post_id: post.id).length
        # json_post[:image] = Image.find_by(post_id: post.id)&.image
        json_post
      end
      render json: @json_posts.sort_by{|j| j[:distance]}
    end

    def good
      @current_user = current_user
      gp = GoodPost.new
      gp.user_id = @current_user.id
      gp.post_id = params[:id]
      if gp.save!
        render json: gp
      else{}
        render json: gp.errors, status: :unprocessable_entity
      end
    end

    # GET /posts/1
    def show
      render json: Post.find(params[:id])
    end

    # POST /posts
    def create
      json = post_params
      @current_user = current_user
      json[:user_id] = @current_user.id
      @post = Post.new(json)
      if @post.save
        render json: @post.as_json(only: [:id, :body, :url, :created_at]),
               status: :created, location: v1_post_url(@post.id)
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /posts/1
    def update
      if @post.update(post_params)
        render json: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end

    # DELETE /posts/1
    def destroy
      @post.destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:body, :url, :longitude, :latitude)
    end

    def distance(lat1, lng1, lat2, lng2)
      x1 = lat1.to_f * Math::PI / 180
      y1 = lng1.to_f * Math::PI / 180
      x2 = lat2.to_f * Math::PI / 180
      y2 = lng2.to_f * Math::PI / 180
      radius = 6378.137
      diff_y = (y1 - y2).abs
      calc1 = Math.cos(x2) * Math.sin(diff_y)
      calc2 = Math.cos(x1) * Math.sin(x2) - Math.sin(x1) * Math.cos(x2) * Math.cos(diff_y)
      numerator = Math.sqrt(calc1 ** 2 + calc2 ** 2)
      denominator = Math.sin(x1) * Math.sin(x2) + Math.cos(x1) * Math.cos(x2) * Math.cos(diff_y)
      degree = Math.atan2(numerator, denominator)
      degree * radius *1000 #to m
    end
  end
end
