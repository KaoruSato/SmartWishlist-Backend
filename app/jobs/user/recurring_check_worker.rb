class User::RecurringCheckWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    User.pluck(:id).each do |user_id|
      User::DiscountCheckScheduler.perform_async(user_id)
    end
  rescue => e
    ExceptionNotifier.notify_exception(e)
    Rails.logger.error e
  end
end
