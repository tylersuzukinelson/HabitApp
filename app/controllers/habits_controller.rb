class HabitsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    @habit = Habit.new permitted_params
    if @habit.save
      redirect_to habits_path
    else
      flash[:notice] = error_messages
      render "new"
    end
  end

  private

  def permitted_params
    params.require(:habit).permit(:title, :description, :interval, :forgiveness)
  end

  def error_messages
    @habit.errors.full_messages.join('; ')
  end

end
