class CommentsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_post
  before_action :set_own_comment, only: [:edit, :update, :destroy]


  def index
    @comments = @post.comments.includes(:user)
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.post = @post
    @comment.user = current_user
    if @comment.save
      redirect_to post_comments_path(@post)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to post_comments_path(@post, @comment)
    else
      render :edit
    end
  end

  def destroy
    if @comment.destroy
      redirect_to post_comments_path(@post)
    end
  end

  private

  def set_own_comment
    @comment = current_user.comments.find_by(id: params[:id])
    if @comment.nil?
      flash[:alert] = 'this post not belongs_to you or not exists'
      redirect_to post_comments_path
    end
  end

  def set_post
    @post = Post.find_by(serial_number: params[:serial_number])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end