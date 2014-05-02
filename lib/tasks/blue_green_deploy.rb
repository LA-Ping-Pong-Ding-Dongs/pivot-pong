require_relative 'route'
require_relative 'cloud_foundry'
require_relative 'blue_green_deploy_config'

class BlueGreenDeployError < StandardError; end
class InvalidRouteStateError < BlueGreenDeployError; end
class InvalidWorkerStateError < BlueGreenDeployError; end

class BlueGreenDeploy
  def self.cf
    CloudFoundry
  end

  def self.make_it_so(domain, app_name, worker_apps, deploy_config, target_color = nil)
    hot_app_name = get_hot_app(deploy_config.hot_url)
    if target_color.nil? && hot_app_name
      target_color = determine_target_color(hot_app_name)
    end

    ready_for_takeoff(hot_app_name, deploy_config, target_color)

    cf.push(full_app_name(app_name, target_color))
    worker_apps.each do |worker_app|
      worker_app_name = full_app_name(worker_app, target_color)
      to_be_cold_worker = full_app_name(worker_app, toggle_blue_green(target_color))

      cf.push(worker_app_name)
      cf.stop(to_be_cold_worker)
    end
    make_hot(app_name, domain, deploy_config, target_color)

    # 2. hot_app = blue + (target_color = green or nil)
    #    - any worker app = green ==> error out "web and workers are out of sync!"
#    rejoice

  end

  def self.ready_for_takeoff(hot_app_name, deploy_config, target_color)
    hot_url = deploy_config.hot_url
    hot_worker_apps = deploy_config.target_worker_app_names
    puts hot_worker_apps.inspect
    if hot_app_name.nil?
      raise InvalidRouteStateError.new(
        "There is no route mapped from #{hot_url} to an app. " +
        "Indicate which app instance you want to deploy by specifying \"blue\" or \"green\".")
    end

    if get_color_stem(hot_app_name) == target_color
      raise InvalidRouteStateError.new(
        "The #{target_color} instance is already hot.")
    end

    apps = cf.apps
    hot_worker_apps.each do |hot_worker|
      if get_color_stem(hot_worker) == target_color && invalid_worker?(hot_worker, apps)
        raise InvalidWorkerStateError.new(
          "Worker #{hot_worker} is already hot (going to #{target_color})")
      end
    end
  end

  def self.invalid_worker?(hot_worker, apps)
    apps.each do |app|
      if app.name == hot_worker && app.state = 'started'
        return true
      end
    end
    return false
  end

  def self.get_color_stem(hot_app_name)
    hot_app_name.slice((hot_app_name.rindex('-') + 1)..(hot_app_name.length))
  end

  def self.determine_target_color(hot_app_name)
    target_color = get_color_stem(hot_app_name)
    toggle_blue_green(target_color)
  end

  def self.toggle_blue_green(target_color)
    target_color == 'green' ? 'blue' : 'green'
  end

  def self.make_hot(app_name, domain, deploy_config, target_color)
    hot_url = deploy_config.hot_url
    hot_app = get_hot_app(hot_url)
    cold_app = full_app_name(app_name, target_color)

    cf.map_route(cold_app, domain, hot_url)
    cf.unmap_route(hot_app, domain, hot_url) if hot_app
  end

  def self.get_hot_app(hot_url)
    cf_routes = cf.routes
    hot_route = cf_routes.find { |route| route.host == hot_url }
    hot_route.nil? ? nil : hot_route.app
  end

  def self.full_app_name(app_name, target_color)
    app_name + "-" + target_color
  end
end
