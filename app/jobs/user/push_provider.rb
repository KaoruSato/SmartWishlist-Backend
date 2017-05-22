class User::PushProvider
  def self.call(user, message)
    new.call(user, message)
  end

  def call(user, message)
    return unless user.device_push_token.present?

    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by!(name: push_app_name(user))
    n.device_token = user.device_push_token
    n.alert = message
    n.save!
  rescue => e
    ExceptionNotifier.notify_exception(e)
    Rails.logger.error e
    Rails.logger.error e.backtrace
  end

  private

  def push_app_name(user)
    if user.sandbox?
      'ios_app_dev'
    else
      'ios_app_production'
    end
  end
end
