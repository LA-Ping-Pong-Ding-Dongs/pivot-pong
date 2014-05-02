class BlueGreenDeployConfig
  attr_reader :hot_url, :worker_app_names

  def initialize(cf_manifest, worker_app_names, target_color = nil)
    host = cf_manifest['applications'][0]['host']
    @hot_url = host.slice(0, host.rindex('-'))
    @worker_app_names = worker_app_names
    @target_color = target_color
  end

  def target_worker_app_names
    @worker_app_names.map do |app|
      "#{app}-#{@target_color}"
    end
  end
end
