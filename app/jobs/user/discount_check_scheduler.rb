class User::DiscountCheckScheduler
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(user_id)
    find_user!(user_id)
    return if user.is_sleeping? && !user.is_system_user?

    user.products.pluck(:id).each do |product_id|
      delay = rand(0..3600).seconds
      Product::DiscountChecker.perform_in(delay, product_id)
    end

  rescue => e
    ExceptionNotifier.notify_exception(e)
    Rails.logger.error e
    Rails.logger.error e.backtrace
  end

  private

  def find_user!(user_id)
    @user = User.find(user_id)
  end

  attr_reader :user
end
