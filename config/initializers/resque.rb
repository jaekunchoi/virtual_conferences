if Rails.env.production? 
  ENV["REDISTOGO_URL"] ||= "redis://redistogo:8b95925b5c9cac0ac7e25aca555c9daa@pearlfish.redistogo.com:10272/"
  uri = URI.parse(ENV["REDISTOGO_URL"])
  redis_credentials = {:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true}
elsif Rails.env.staging?
	ENV["REDISTOGO_URL"] ||= "redis://redistogo:04d94fde444a24fc1e85d91e1be9f59d@barreleye.redistogo.com:11575/"
	uri = URI.parse(ENV["REDISTOGO_URL"])
	redis_credentials = {:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true}
elsif Rails.env.development?
	redis_credentials = {:host => "localhost", :port => 6379}
elsif Rails.env.test? #dummy credentials for test servers
	redis_credentials = {:host => "localhost", :port => 6379}
end

Resque.redis = Redis.new(redis_credentials)
Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds
Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }
