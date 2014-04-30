namespace :cf do
  desc 'Only run on the first application instance'
  task :on_first_instance do
    instance_index = JSON.parse(ENV['VCAP_APPLICATION'])['instance_index'] rescue nil
    exit(0) unless instance_index == 0
  end

  desc 'Deploy this application to Cloud Foundry'
  task :deploy, :app_name do |t, args|
    app_name = args[:app_name]
    system("cf push #{app_name}")
  end

  def determine_hot_url(app_name, target_space)
    cf_manifest = load_manifest
    app_name = app_name+'-'+target_space+'-green'
    green_app_config = cf_manifest['applications'].find { |cf_app| cf_app['name'] == app_name }
    green_app_config['host'].chomp('-green')
  end

  def load_manifest
    YAML.load_file('manifest.yml')
  end

  desc 'Reroutes "live" traffic to specified app through provided URL'
  task :make_hot, :app_name, :target_space, :blue_or_green do |t, args|
    desired_hot_app = [args[:app_name], args[:target_space], args[:blue_or_green]].join '-'
    hot_url = determine_hot_url(args[:app_name], args[:target_space])

    # determine which app is currently "hot"
    current_hot_app = `cf routes | grep '#{hot_url}' | awk '{ print $3 }'`

    @cmd.backtick("cf routes | grep '......")

    current_hot_app.chomp!

    # unmap from current hot
    t = "cf unmap-route #{current_hot_app} cfapps.io  -n #{hot_url}"
    puts t
    #system(t)

    # map to new hot
    x = "cf map-route #{desired_hot_app} cfapps.io -n #{hot_url}"
    puts x
    #system(x)
  end
end
