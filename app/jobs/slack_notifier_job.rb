class SlackNotifierJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(message)
    return if Rails.env.test?

    Slack::Notifier.new(
      ENV.fetch("SLACK_WEBHOOK"),
      channel: "tracky",
      username: "PriceWatcher-#{Rails.env}"
    ).ping message, icon_emoji: ":goat:"
  rescue => e
    ExceptionNotifier.notify_exception(e)
  end
end
