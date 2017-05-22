require 'grackle'

class TwitterBotJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(message)
    return if Rails.env.test?
    client.statuses.update!(status: message)
  rescue => e
    ExceptionNotifier.notify_exception(e)
  end

  private

  def client
    @_client ||= Grackle::Client.new(auth: {
      type: :oauth,
      consumer_key: ENV.fetch('TWITTER_KEY'),
      consumer_secret: ENV.fetch('TWITTER_SECRET'),
      token: ENV.fetch('TWITTER_ACCESS_TOKEN'),
      token_secret: ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
    }).tap do |cl|
      cl.ssl = true
    end
  end
end
