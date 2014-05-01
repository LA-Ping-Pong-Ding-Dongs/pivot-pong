require File.join(File.dirname(__FILE__), '.', 'blue_green_deploy')

namespace :cf do
  desc 'Only run on the first application instance'
  task :on_first_instance do
    instance_index = JSON.parse(ENV['VCAP_APPLICATION'])['instance_index'] rescue nil
    exit(0) unless instance_index == 0
  end

  desc 'Reroutes "live" traffic to specified app through provided URL'
  task :blue_green_deploy, :domain, :web_app_name do |t, args|
    blue_or_green = args.extras.pop if args.extras.last == 'blue' || args.extras.last == 'green'
    worker_apps = args.extras

    deploy_config = BlueGreenDeployConfig.new(load_manifest)
    puts deploy_config.inspect
    BlueGreenDeploy.make_it_so(args[:domain], args[:web_app_name], worker_apps, deploy_config, blue_or_green)
  end

  def load_manifest
    YAML.load_file('manifest.yml')
  end
end
