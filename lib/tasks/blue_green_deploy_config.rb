class BlueGreenDeployConfig
  attr_reader :hot_url

  def initialize(cf_manifest)
    host = cf_manifest['applications'][0]['host']
    @hot_url = host.slice(0, host.rindex('-'))
  end

end
