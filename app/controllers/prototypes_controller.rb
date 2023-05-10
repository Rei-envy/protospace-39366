class PrototypesController < ApplicationController
    before_action :authenticate_user!, only:  [:new, :edit, :destroy]
    before_action :move_to_index, only: :edit

    def index
        @prototype = Prototype.all
    end

    def new
        @prototype = Prototype.new
        # @user = User.find(current_user.id)
    end

    def create
        @user = User.find(current_user.id)
        @prototype = @user.prototypes.new(prototype_params)
        if @prototype.save
            redirect_to root_path
        else
            render :new
        end
        # # @user = User.find(current_user.id)
        # @prototype = Prototypes.new(prototype_params)
        # if @prototype.save
        #     redirect_to root_path
        # else
        #     render :new
        # end
    end

    def show
        @prototype = Prototype.find(params[:id])
        @comment = Comment.new
        @comments = @prototype.comments
    end

    def edit
        @prototype = Prototype.find(params[:id])
    end

    def update
        # prototype = Prototype.find(params[:id])
        # if prototype.update(prototype_params)
        #     redirect_to prototype_path(prototype.id)
        @prototype = Prototype.find(params[:id])
        if @prototype.update(prototype_params)
            redirect_to prototype_path(@prototype.id)
        else
            render :edit
        end
    end

    def destroy
        prototype = Prototype.find(params[:id])
        prototype.destroy
        redirect_to root_path
    end

    private
    def prototype_params
        # : current_user.id, prototype_id: params[:prototype_id] 入れるかも
        params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
    end

    def move_to_index
        @prototype = Prototype.find(params[:id])
        unless current_user.id == @prototype.user_id
          redirect_to action: :index
        end
    end
end
