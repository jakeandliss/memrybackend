url = ENV['REDIS_URL'] || 'redis://localhost:6379'
$redis = Redis.new(url: url)

REDIS = Redis.current = $redis