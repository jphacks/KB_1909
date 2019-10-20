module V2
  class UsersController < ApplicationController
  before_action :authenticate!, only: [:update, :destroy, :me]

  # GET /users
  def index
    @users = User.all

    render json: @users.as_json(only: [:id, :name, :email, :image])
  end

  def me
    render json: current_user.as_json(only: [:id, :name, :email, :token, :image])
  end

  # GET /users/1
  def show
    render json: set_user.as_json(only: [:id, :name, :email, :image])
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user.as_json(only: [:id, :name, :email, :token]), status: :created, location: v1_user_path(@user.id)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user.as_json(only: [:id, :name, :email, :token])
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def log_in
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      # @user.regenerate_token
      render json: @user.as_json(only: [:id, :name, :email, :token, :image])
    else
      render json: { errors: ['cannot logged_in'] }, status: 401
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:name, :email, :password, :password_confirmation, :image)
    end
  end
end
