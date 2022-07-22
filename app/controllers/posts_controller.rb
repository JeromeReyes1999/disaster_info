class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_post, only: :show
  before_action :set_own_post, only: [:edit, :update, :destroy]
  require 'open-uri'

  def index
    @posts = Post.left_joins(:comments).group(:id).order('COUNT(comments.id) DESC').includes(:user, :disaster)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    # for non-developer:
    # @post.ip = request.remote_ip
    @post.ip = open('http://whatismyip.akamai.com').read
    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to posts_path
    else
      render :edit
    end
  end

  def show; end

  def destroy
    if @post.comments.size.zero?
      @post.destroy
    else
      flash[:notice] = "this post has comments you can't delete it"
    end
    redirect_to posts_path
  end

  def redirect
    @short = params[:short_url]
    @url = Post.find_by(short_url: @short)
    if @url.nil? #if 404
      content_not_found
    else
      redirect_to post_path(@url)
    end
  end

  private

  def set_own_post
    @post = current_user.posts.find_by(serial_number: params[:serial_number])
    if @post.nil?
      flash[:alert] = 'this post not belongs_to you or not exists'
      redirect_to posts_path
    end
  end

  def post_params
    params.require(:post).permit(:title, :content, :address, :image, :disaster_id)
  end

  def set_post
    @post = Post.find_by(serial_number: params[:serial_number])
  end

  def content_not_found
    render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

end
