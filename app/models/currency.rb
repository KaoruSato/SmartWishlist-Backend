class Currency < ApplicationRecord
  API_HOST = "https://api.fixer.io"
  LIST = %w(
    AUD BGN BRL CAD CHF CNY CZK DKK GBP HKD HRK HUF IDR ILS INR JPY KRW MXN MYR NOK NZD PHP PLN RON RUB SEK SGD THB TRY ZAR EUR USD
  )

  def self.fetch_current_usd_rates
    response = Faraday.new(API_HOST).get('/latest?base=USD')

    JSON.parse(response.body).fetch('rates').each do |name, rate|
      Currency.find_by(name: name)&.update(usd_rate: rate.round(4))
    end
  end
end
