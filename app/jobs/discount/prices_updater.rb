class Discount::PricesUpdater
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    Discount.find_each do |discount|
      discount.update_usd_prices
    end
  rescue => e
    ExceptionNotifier.notify_exception(e)
    Rails.logger.error e
    Rails.logger.error e.backtrace
  end
end
