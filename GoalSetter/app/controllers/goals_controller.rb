class GoalsController < ApplicationController
  before_action :require_sign_in
  def index
    @goals = Goal.all.where(view_status: "public")
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params.merge(user_id: current_user.id))
    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def show
    @goal = Goal.find(params[:id])
  end

  private
  def goal_params
    params.require(:goal).permit(:title, :description, :view_status)
  end
end
