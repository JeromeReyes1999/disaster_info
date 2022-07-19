class Admin::DisastersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @disasters = Disaster.all
  end

  def new
    @disaster = Disaster.new
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

end
