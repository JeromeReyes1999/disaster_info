class Admin::DisastersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_disaster, only: [:edit, :update, :destroy]


  def index
    @disasters = Disaster.all
  end

  def new
    @disaster = Disaster.new
  end

  def edit; end

  def update
    if @disaster.update(disaster_params)
      redirect_to admin_disasters_path
    else
      render :edit
    end
  end

  def destroy
    if @disaster.post.size.zero?
      @disaster.destroy
    else
      flash[:notice] = "this disaster type is currently in use in a post"
    end
    redirect_to admin_disasters_path
  end

  def create
    @disaster = Disaster.new(disaster_params)
    if @disaster.save
      redirect_to admin_disasters_path
    else
      render :new
    end
  end

  def check_admin
    unless current_user.admin?
      flash[:notice] = "You do not have permission"
      redirect_to posts_path
    end
  end

  def disaster_params
    params.require(:disaster).permit(:category)
  end

  def set_disaster
    @disaster = Disaster.find(params[:id])
  end

end
