$redis = if Rails.env.staging? || Rails.env.production?
           credentials = JSON.parse(ENV['VCAP_SERVICES'])['rediscloud'].first['credentials']
           hostname = credentials['hostname']
           port = credentials['port']
           password = credentials['password']

           Redis.new(host: hostname, port: port, password: password)
         else
           Redis.new(host: '127.0.0.1', port: '6379')
         end
