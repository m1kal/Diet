require 'redis'

# RedisSerializer
class RedisSerializer
  def self.save(json, params)
    Redis.new(password: params[:password]).set(params[:key], json)
  end

  def self.load(params)
    Redis.new(password: params[:password]).get(params[:key])
  end
end
