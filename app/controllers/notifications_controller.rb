class NotificationsController < ApplicationController
  before_action :my_notifications, except: :update

  def schedule_index
    if params[:action_type] == "create"
      notification_ids = @recieve_notifications.creation_notification_for_schedule.ids
      @creation_schedules = Schedule.joins(:notifications).where(notifications: {id: notification_ids})
                                                .order(:scheduled_date, :scheduled_start_time)
                                                .select('schedules.*, notifications.id AS notification_id, notifications.sender_id AS sender_code')
    elsif params[:action_type] == "update"
      notification_ids = @recieve_notifications.updation_notification_for_schedule.ids
      @updation_schedules = Schedule.joins(:notifications).where(notifications: {id: notification_ids})
                                                .order(:scheduled_date, :scheduled_start_time)
                                                .select('schedules.*, notifications.*, notifications.id AS notification_id')
    elsif params[:action_type] == "delete"
      notification_ids = @recieve_notifications.delete_notification_for_schedule.ids
      @deletion_notification_for_schedules = Notification.where(notifications: {id: notification_ids})
                                                         .order(:before_value_1, :before_value_2)
    end
  end

  def task_index
    if params[:action_type] == "create"
      notification_ids = @recieve_notifications.creation_notification_for_task.ids
      @creation_tasks = Task.joins(:notifications).where(notifications: {id: notification_ids})
                                                  .select('tasks.*, notifications.id AS notification_id, notifications.sender_id AS sender_code')
    elsif params[:action_type] == "update"
      notification_ids = @recieve_notifications.updation_notification_for_task.ids
      @notifications_for_update_task = Notification.includes(:task).where(id: notification_ids)
    elsif params[:action_type] == "delete"
      notification_ids = @recieve_notifications.delete_notification_for_task.ids
      @deletion_notification_for_tasks = Notification.where(notifications: { id: notification_ids })
    end
  end

  def construction_schedule_index
    if params[:action_type] == "create"
      notification_ids = @recieve_notifications.creation_notification_for_construction_schedule.ids
      @creation_construction_schedules = ConstructionSchedule.joins(:notifications).where(notifications: {id: notification_ids})
                                                             .order_start_date
                                                             .select('construction_schedules.*, notifications.id AS notification_id, notifications.sender_id AS sender_code')
    elsif params[:action_type] == "update"
      notification_ids = @recieve_notifications.updation_notification_for_construction_schedule.ids
      @updation_construction_schedules = ConstructionSchedule.joins(:notifications).where(notifications: {id: notification_ids})
                                                .order_start_date
                                                .select('construction_schedules.*, notifications.*, notifications.id AS notification_id')
    elsif params[:action_type] == "delete"
      @deletion_notification_for_construction_schedules = @recieve_notifications.delete_notification_for_construction_schedule
    end
  end

  def updates
    params[:notification_ids].each do |n_id|
      notification = Notification.find(n_id.to_i)
      notification.update(status: 1)
    end
    if current_vendor_manager
      redirect_to top_vendor_managers_path
    else
      redirect_to send("#{ login_user.auth }s_top_url")
    end
  end

  private
    def my_notifications
      @recieve_notifications = login_user.recieve_notifications
    end
end
