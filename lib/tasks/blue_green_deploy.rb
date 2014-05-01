require_relative 'route'
require_relative 'cloud_foundry'
require_relative 'blue_green_deploy_config'

class BlueGreenDeployError < StandardError; end
class InvalidRouteStateError < BlueGreenDeployError; end

class BlueGreenDeploy

  def self.make_it_so(domain, app_name, worker_apps, deploy_config, blue_or_green = nil)
    hot_app_name = get_hot_app(deploy_config.hot_url)
    if blue_or_green.nil? && hot_app_name
      blue_or_green = determine_blue_green(hot_app_name)
    end

    ready_for_takeoff(hot_app_name, deploy_config.hot_url, blue_or_green)

    CloudFoundry.push(full_app_name(app_name, blue_or_green))
#   worker_apps.each do |worker_app|
#     to_be_hot_worker = full_app_name(worker_app, blue_or_green)
#     to_be_cold_worker = full_app_name(worker_app, green_or_blue)
#
#     CloudFoundry.push(to_be_hot_worker)
#     CloudFoundry.stop(to_be_cold_worker)
#   end
    make_hot(app_name, domain, deploy_config, blue_or_green)

#    ensure_everything_is_kosh(...) - that means web and workers sync
    # 1. hot_app = green + blue_or_green = green ==> error out "green is already live!"
    # 2. hot_app = blue + (blue_or_green = green or nil)
    #    - any worker app = green ==> error out "web and workers are out of sync!"
    #
    #
#    deploy changes to cold slice
#    push all related workers to cold worker slices
#    stop all related old fart worker bees
#    map route to new hot
#    unmap route to old hot
#    rejoice

  end

  def self.ready_for_takeoff(hot_app_name, hot_url, blue_or_green)
    if hot_app_name.nil?
      raise InvalidRouteStateError.new(
        "There is no route mapped from #{hot_url} to an app. " +
        "Indicate which app instance you want to deploy by specifying \"blue\" or \"green\".")
    end

    if get_color_stem(hot_app_name) == blue_or_green
      raise InvalidRouteStateError.new(
        "The #{blue_or_green} instance is already hot.")
    end
  end

  def self.get_color_stem(hot_app_name)
    hot_app_name.slice((hot_app_name.rindex('-') + 1)..(hot_app_name.length))
  end

  def self.determine_blue_green(hot_app_name)
    blue_or_green = get_color_stem(hot_app_name)
    blue_or_green == 'green' ? 'blue' : 'green'
  end

  def self.make_hot(app_name, domain, deploy_config, blue_or_green)
    hot_url = deploy_config.hot_url
    hot_app = get_hot_app(hot_url)
    cold_app = full_app_name(app_name, blue_or_green)

    CloudFoundry.map_route(cold_app, domain, hot_url)
    CloudFoundry.unmap_route(hot_app, domain, hot_url) if hot_app
  end

  def self.get_hot_app(hot_url)
    cf_routes = CloudFoundry.routes
    hot_route = cf_routes.find { |route| route.host == hot_url }
    hot_route.nil? ? nil : hot_route.app
  end

  def self.full_app_name(app_name, blue_or_green)
    app_name + "-" + blue_or_green
  end
end
