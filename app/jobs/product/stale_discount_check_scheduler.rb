class Product::StaleDiscountCheckScheduler
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    Product.currently_discounted.pluck(:id).each do |product_id|
      delay = rand(0..240).seconds
      Product::StaleDiscountedUpdater.perform_in(delay, product_id)
    end
  rescue => e
    ExceptionNotifier.notify_exception(e)
    Rails.logger.error e
    Rails.logger.error e.backtrace
  end
end
