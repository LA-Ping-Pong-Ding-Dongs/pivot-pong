require_relative 'route'
require_relative 'cloud_foundry'
require_relative 'blue_green_deploy_config'

class BlueGreenDeployError < StandardError; end
class InvalidRouteStateError < BlueGreenDeployError; end

class BlueGreenDeploy
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

  def self.make_it_so(app_name, domain, deploy_config, blue_or_green = nil)
    hot_app_name = get_hot_app(deploy_config.hot_url)
    if blue_or_green.nil? && hot_app_name
      blue_or_green = determine_blue_green(hot_app_name)
    end

    ready_for_takeoff(hot_app_name, deploy_config.hot_url, blue_or_green)

    CloudFoundry.push(calc_cold_app_name(app_name, blue_or_green))
    make_hot(app_name, domain, deploy_config, blue_or_green)
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

    if hot_app
      if hot_app.ends_with?(blue_or_green)
        raise InvalidRouteStateError.new("#{hot_app} is already hot.")
      end
      CloudFoundry.unmap_route(hot_app, domain, hot_url)
    end

    cold_app = calc_cold_app_name(app_name, blue_or_green)
    CloudFoundry.map_route(cold_app, domain, hot_url)

  end

  def self.get_hot_app(hot_url)
    cf_routes = CloudFoundry.routes
    hot_route = cf_routes.find { |route| route.host == hot_url }
    hot_route.nil? ? nil : hot_route.app
  end

  def self.calc_cold_app_name(app_name, blue_or_green)
    app_name + "-" + blue_or_green
  end
end
