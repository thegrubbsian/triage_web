class TasksController < ApplicationController

  before_action :authorize!

  def index
    render json: current_user.tasks.in_order
  end

  def create
    task = current_user.tasks.create task_params
    render json: task
  end

  def update
    task = current_user.tasks.find params[:id]
    task.update_attributes task_params
    render json: task
  end

  def destroy
    task = current_user.tasks.find params[:id]
    task.destroy
    render json: true
  end

  private

  def task_params
    params.require(:task).permit(:name, :state, :description, :due_at, :order_index)
  end

end
