if Rails.env.test?
  logger = Rails.logger

  def logger.error message
    p message
  end
end
