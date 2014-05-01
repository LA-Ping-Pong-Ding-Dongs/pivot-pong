require File.join(File.dirname(__FILE__), '.', 'blue_green_deploy')

namespace :cf do
  desc 'Only run on the first application instance'
  task :on_first_instance do
    instance_index = JSON.parse(ENV['VCAP_APPLICATION'])['instance_index'] rescue nil
    exit(0) unless instance_index == 0
  end

  desc 'Reroutes "live" traffic to specified app through provided URL'
  task :blue_green_deploy, :app_name, :domain, :blue_or_green do |t, args|
    deploy_config = BlueGreenDeployConfig.new(load_manifest)
    BlueGreenDeploy.make_it_so(args[:app_name], args[:domain], deploy_config, args[:blue_or_green])
  end

  def load_manifest
    YAML.load_file('manifest.yml')
  end
end
