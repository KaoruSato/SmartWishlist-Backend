require 'redis'

$redis = if Rails.env.test?
  require 'mock_redis'
  MockRedis.new
else
  Redis.new(url: ENV.fetch("REDIS_URL"))
end
