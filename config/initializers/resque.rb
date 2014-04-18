if Rails.env.staging? || Rails.env.production?
  credentials = JSON.parse(ENV['VCAP_SERVICES'])['rediscloud'].first['credentials']
  hostname = credentials['hostname']
  port = credentials['port']
  password = credentials['password']

  Resque.redis = "redis://:#{password}@#{hostname}:#{port}"
else
  Resque.redis = 'redis://127.0.0.1:6379'
end
