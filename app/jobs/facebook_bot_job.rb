class FacebookBotJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(message, link_url)
    return if Rails.env.test?
    client.put_connections('me', 'feed',
      message: message,
      link: link_url
    )
  rescue => e
    ExceptionNotifier.notify_exception(e)
    Rails.logger.error e
    Rails.logger.error e.backtrace
  end

  private

  def client
    @_client ||= Koala::Facebook::API.new(ENV.fetch('FB_ACCESS_TOKEN'))
  end
end
