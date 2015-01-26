class HabitsController < ApplicationController
  before_action :get_habit, only: [:edit, :show, :update, :destroy]
  before_action :authenticate_user!

  def index
    @habits = current_user.habits.order("current_streak DESC")
  end

  def new
  end

  def create
    @habit = Habit.new permitted_params
    @habit.user = current_user
    if @habit.save
      redirect_to habits_path
    else
      flash[:notice] = error_messages
      render "new"
    end
  end

  def edit
  end

  def show
  end

  def update
    if @habit.update permitted_params
      redirect_to habits_path
    else
      flash[:notice] = error_messages
      render "edit"
    end
  end

  def destroy
    if @habit.destroy
      redirect_to habits_path
    else
      flash[:notice] = error_messages
      render @habit
    end
  end

  def increment
    @habit = current_user.habits.find params[:id]
    if @habit.logs.last.nil? || Time.now.in_time_zone("UTC") - @habit.logs.last.logged.in_time_zone("UTC") >= @habit.turnover_time*3600
      @log = Log.new
      @log.habit = @habit
      @log.user = current_user
      @log.logged = DateTime.now
      if @log.save
        @habit.current_streak = @habit.logs.count
        if @habit.save
          redirect_to habits_path
        else
          redirect_to habits_path, notice: error_messages
        end
      else
        redirect_to habits_path, notice: @log.errors.full_messages.join('; ')
      end
    else
      redirect_to habits_path, notice: @habit.turnover_time_not_elapsed
    end
  end

  private

  def get_habit
    @habit = current_user.habits.find params[:id]
  end

  def permitted_params
    params.require(:habit).permit(:title, :description, :interval, :forgiveness, :turnover_time)
  end

  def error_messages
    @habit.errors.full_messages.join('; ')
  end

end
