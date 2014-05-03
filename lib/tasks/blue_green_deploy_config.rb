class BlueGreenDeployConfig
  attr_reader :hot_url, :worker_app_names
  attr_accessor :target_color

  def initialize(cf_manifest, worker_app_names, target_color = nil)
    host = cf_manifest['applications'][0]['host']
    @hot_url = host.slice(0, host.rindex('-'))
    @worker_app_names = worker_app_names
    @target_color = target_color
  end

  def target_web_app_name

  end

  def is_in_target?(app)
    self.class.get_color_stem(app) == @target_color
  end

  def target_worker_app_names
    @worker_app_names.map do |app|
      "#{app}-#{@target_color}"
    end
  end

  def self.toggle_app_color(target_app_name)
    new_color = toggle_color(get_color_stem(target_app_name))
    new_app = target_app_name.slice(0..(target_app_name.rindex('-') - 1))
    new_app = "#{new_app}-#{new_color}"
  end

  def self.get_color_stem(app_name)
    app_name.slice((app_name.rindex('-') + 1)..(app_name.length))
  end

  def self.toggle_color(target_color)
    target_color == 'green' ? 'blue' : 'green'
  end
end
