class PrototypesController < ApplicationController

before_action :authenticate_user!, only: [:edit]
before_action :move_to_index, except: [:index, :show]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:prototype)
  end

  def edit
    @prototype = Prototype.find(params[:id])
    @user = User.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(prototype_params)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to prototypes_path
  end   


  private
    def prototype_params
      params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
    end

    def move_to_index
      unless current_user.id == @user
        redirect_to action: :index
      end
    end

end