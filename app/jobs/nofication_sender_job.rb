class NotificationSenderJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    Rpush.push
    Rpush.apns_feedback
  rescue => e
    ExceptionNotifier.notify_exception(e)
    Rails.logger.error e
    Rails.logger.error e.backtrace
  end
end
