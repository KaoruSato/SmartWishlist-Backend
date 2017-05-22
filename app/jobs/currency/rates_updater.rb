class Currency::RatesUpdater
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    Currency.fetch_current_usd_rates
  end
end

