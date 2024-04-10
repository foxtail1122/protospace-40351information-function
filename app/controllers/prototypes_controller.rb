class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new,:edit,:destroy]
  before_action :move_to_index, except: [:index, :show]

  def index
    @prototypes = Prototype.includes(:user).order("created_at DESC")
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
      redirect_to root_path(@prototype)
    else
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
    unless @prototype.user_id == current_user.id
      redirect_to action: :index
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  private
  def prototype_params
    params[:prototype].permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
end
