class NotificationSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification_setting, only: %i[update]
  
  def index
    @settings = NotificationSetting.where(user: @current_user)

    render json: @settings
  end

  def update
    if @setting.update(notification_setting_params)
      render json: @setting
    else
      render json: @setting.errors, status: :unprocessable_entity
    end
  end

  private
  
  def set_notification_setting
    @setting = NotificationSetting.find_by(user: @current_user, id: params[:id])
  end

  def notification_setting_params
    params.permit(:sms_enabled, :email_enabled, :push_enabled)
  end
end
