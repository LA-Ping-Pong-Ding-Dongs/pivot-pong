require 'spec_helper'
require 'rake'

class BlueGreenDeployConfig
  attr_reader :hot_url

  def initialize(cf_manifest)
    host = cf_manifest['applications'][0]['host']
    @hot_url = host.slice(0, host.rindex('-'))
  end

end

class BlueGreenDeployError < StandardError; end
class InvalidRouteStateError < BlueGreenDeployError; end

# rake cf:blue_green_deploy[pivot-pong,cfapps.io,blue]

class BlueGreenDeploy
  def self.make_it_so(app_name, domain, deploy_config, blue_or_green = nil)
    if blue_or_green.nil?
      hot_app_name = get_hot_app(deploy_config.hot_url)
      blue_or_green = (hot_app_name.slice((hot_app_name.rindex('-') + 1)..(hot_app_name.length)))
      blue_or_green = blue_or_green == 'green' ? 'blue' : 'green'
    end

    make_hot(app_name, domain, deploy_config, blue_or_green)
  end


# def self.deploy_blue_green()
#
#   blue_or_green = calculate_blue_or_green(...)
#   make(app_name,
# end

  def self.make_hot(app_name, domain, deploy_config, blue_or_green)
    hot_url = deploy_config.hot_url
    hot_app = get_hot_app(hot_url)

    if hot_app
      if hot_app.ends_with?(blue_or_green)
        raise InvalidRouteStateError.new("#{hot_app} is already hot.")
      end
      CloudFoundry.unmap_route(hot_app, domain, hot_url)
    end

    cold_app = app_name + "-" + blue_or_green
    CloudFoundry.map_route(cold_app, domain, hot_url)
  end

  def self.get_hot_app(hot_url)
    cf_routes = CloudFoundry.routes
    hot_route = cf_routes.find { |route| route.host == hot_url }
    hot_route.nil? ? nil : hot_route.app
  end
end

class CloudFoundry
  def self.routes
    routes = []
    lines = CommandLine.backtick("cf routes").lines
    found_header = false
    lines.each do |line|
      line = line.split
      if line[0] == 'host'
        found_header = true
        next
      end

      if found_header
        routes << Route.new(line[0], line[1], line[2])
      end
    end
    routes
  end

  def self.unmap_route(app, domain, host)
    CommandLine.system("cf unmap-route #{app} #{domain} -n #{host}")
  end

  def self.map_route(app, domain, host)
    CommandLine.system("cf map-route #{app} #{domain} -n #{host}")
  end
end

class Route
  attr_reader :host, :domain, :app
  def initialize(host, domain, app)
    @host = host
    @domain = domain
    @app = app == '' ? nil : app
  end
end

class CommandLine
  def self.backtick(command)
    `CF_COLOR=false #{command}`
  end

  def self.system(command)
    puts "executing \"#{command}\""
    Kernel.system("CF_COLOR=false #{command}")
  end
end

describe BlueGreenDeploy do
  let(:cf_manifest) { YAML.load_file('spec/tasks/manifest.yml') }
  let(:deploy_config) { BlueGreenDeployConfig.new(cf_manifest) }

  describe '#get_hot_app' do
    subject { BlueGreenDeploy.get_hot_app(hot_url) }
    let(:hot_app) { 'app_name-green' }
    let(:hot_url) { 'la-pong' }
    let(:routes) {
      [
        Route.new('app_name-blue', 'cfapps.io', 'app_name-blue'),
        Route.new('app_name-green', 'cfapps.io', 'app_name-green'),
        Route.new(hot_url, 'cfapps.io', hot_app)
      ]
    }

    before do
      allow(CloudFoundry).to receive(:routes).and_return(routes)
    end

    it 'returns the app mapped to that Host URL' do
      expect(subject).to eq hot_app
    end

    context 'when there is no app mapped to the hot url' do
      let(:routes) {
        [
          Route.new('app_name-blue', 'cfapps.io', 'app_name-blue'),
          Route.new('app_name-green', 'cfapps.io', 'app_name-green'),
        ]
      }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '#make_it_so' do
    context 'when blue/green is specified' do
      it 'attempts to make that the hot app' do
        app_name = 'app_name'
        domain = 'cfapps.io'
        blue_or_green = 'green'
        expect(BlueGreenDeploy).to receive(:make_hot).with(app_name, domain, deploy_config, blue_or_green)
        BlueGreenDeploy.make_it_so(app_name, domain, deploy_config, blue_or_green)
      end
    end

    context 'when blue/green is omitted' do
      subject { BlueGreenDeploy.make_it_so(app_name, domain, deploy_config) }
      let(:app_name) { 'app_name' }
      let(:domain) { 'cfapps.io' }
      let(:hot_url) { 'la-pong' }
      before do
        @cf_route_table = [
          Route.new("#{app_name}-blue", domain, "#{app_name}-blue"),
          Route.new("#{app_name}-green", domain, "#{app_name}-green"),
          Route.new(hot_url, domain, "#{app_name}-#{current_hot_app}")
        ]
        allow(CloudFoundry).to receive(:routes).and_return(@cf_route_table)
        allow(CloudFoundry).to receive(:unmap_route).with("#{app_name}-#{current_hot_app}", 'cfapps.io', hot_url) do
          @cf_route_table.pop; nil
        end
        allow(CloudFoundry).to receive(:map_route) do |app, domain, host|
          @cf_route_table.delete_if { |route| route.host == host }
          @cf_route_table.push(Route.new(host, domain, app))
        end
      end

      context 'green is the current hot app' do
        let(:current_hot_app) { 'green' }

        it 'makes blue the current hot app' do
          subject
          route_to_hot_app = @cf_route_table.find { |route| route.host == hot_url }
          expect(route_to_hot_app.app).to eq "#{app_name}-blue"
        end
      end

      context 'blue is the current hot app' do
        let(:current_hot_app) { 'blue' }

        it 'makes green the current hot app' do

        end
      end

      context 'there is no current hot app' do

      end
    end



  end

  describe '#make_hot' do
    let(:app_name) { 'app_name' }
    let(:target_app) { 'blue' }
    let(:current_hot_app) { 'green' }
    let(:hot_url) { 'la-pong' }
    subject { BlueGreenDeploy.make_hot(app_name, 'cfapps.io', deploy_config, target_app) }

    before do
      @cf_route_table = [
        Route.new('app_name-blue', 'cfapps.io', 'app_name-blue'),
        Route.new('app_name-green', 'cfapps.io', 'app_name-green'),
        Route.new(hot_url, 'cfapps.io', "#{app_name}-#{current_hot_app}")
      ]
      allow(CloudFoundry).to receive(:routes).and_return(@cf_route_table)
      allow(CloudFoundry).to receive(:unmap_route).with("#{app_name}-#{current_hot_app}", 'cfapps.io', hot_url) do
        @cf_route_table.pop; nil
      end
      allow(CloudFoundry).to receive(:map_route) do |app, domain, host|
        @cf_route_table.delete_if { |route| route.host == host }
        @cf_route_table.push(Route.new(host, domain, app))
      end
    end

    context 'when the target_app is already hot' do
      let(:current_hot_app) { target_app }

      it 'throws an InvalidRouteState exception' do
        expect{ subject }.to raise_error(InvalidRouteStateError)
      end
    end

    context 'when there is no current hot app' do
      before do
        @cf_route_table.pop  # remove the "hot url" route
      end

      it 'the target_app is mapped to the hot_url' do
        subject
        expect(BlueGreenDeploy.get_hot_app(hot_url)).to eq "app_name-#{target_app}"
      end
    end

    context 'when there IS a hot URL route, but it is not mapped to any app' do
      before do
        @cf_route_table.pop  # remove the "hot url" route
        @cf_route_table.push(Route.new(hot_url, 'cfapps.io', nil))
      end

      it 'the target_app is mapped to the hot_url' do
        subject
        expect(BlueGreenDeploy.get_hot_app(hot_url)).to eq "app_name-#{target_app}"
      end
    end

    context 'when the hot url IS mapped to an app, already' do
      it 'the app that was mapped to the hot_url is no longer mapped to hot_url' do
        subject
        expect(BlueGreenDeploy.get_hot_app(hot_url)).to_not eq "app_name-#{current_hot_app}"
      end

      it 'the target_app is mapped to the hot_url' do
        subject
        expect(BlueGreenDeploy.get_hot_app(hot_url)).to eq "app_name-#{target_app}"
      end
    end
  end
# describe 'make_hot task - it\'s smoking' do
#   # pre-conditions?
#   let!(:make_hot) { ['app_name', 'cfapps.io', 'blue'] }
#
#   it 'determines the desired hot app' do
#     expect(desired_hot_app).to eq 'app_name-blue'
#   end
#
#   it 'determines the current hot app'   # operations
#
#
#   it 'leaves the new hot app mapped'          # post-condition
# end
end


describe CloudFoundry do
  describe '#routes' do
    subject { CloudFoundry.routes }

    context 'there is a route defined in the current organization' do
      let(:cli_routes_output) {
        <<-CLI
        Getting routes as pivot-pong-developers@googlegroups.com ...

        host                 domain      apps
        pivot-pong-blue      cfapps.io   pivot-pong-staging-blue
        pivot-pong-green     cfapps.io   pivot-pong-staging-green
        la-pong              cfapps.io   pivot-pong-staging-green
        CLI
      }

      before do
        allow(CommandLine).to receive(:backtick).with('cf routes').and_return(cli_routes_output)
      end

      it 'parses the CLI "routes" output into a collection of Route objects, one for each route' do
        expect(subject).to be_kind_of(Array)
        expect(subject.length).to eq 3
        expect(subject[0].host).to eq 'pivot-pong-blue'
        expect(subject[0].domain).to eq 'cfapps.io'
        expect(subject[0].app).to eq 'pivot-pong-staging-blue'
      end
    end
  end

  describe '#map_route' do
    let(:app) { 'the-app' }
    let(:domain) { 'the-domain' }
    let(:host) { 'the-host' }

    subject { CloudFoundry.map_route(app, domain, host) }

    it 'invokes the CloudFoundry CLI command "map-route" with the proper set of parameters' do
      expect(CommandLine).to receive(:system).with("cf map-route #{app} #{domain} -n #{host}")
      subject
    end
  end

  describe '#unmap_route' do
    let(:app) { 'the-app' }
    let(:domain) { 'the-domain' }
    let(:host) { 'the-host' }

    subject { CloudFoundry.unmap_route(app, domain, host) }

    it 'invokes the CloudFoundry CLI command "unmap-route" with the proper set of parameters' do
      expect(CommandLine).to receive(:system).with("cf unmap-route #{app} #{domain} -n #{host}")
      subject
    end
  end
end

describe Route do
  describe '.initialize' do
    context 'when supplied an empty "app"' do
      it 'reports "app" as nil' do
        expect(Route.new('blah', 'blah', '').app).to be_nil
      end
    end
  end
end


describe BlueGreenDeployConfig do
  describe '#initialize' do
    subject { BlueGreenDeployConfig.new(cf_manifest) }
    context 'given a parsed conforming manifest.yml' do
      let(:cf_manifest) { YAML.load_file('spec/tasks/manifest.yml') }

      it 'calculates the "Hot URL"' do
        expect(subject.hot_url).to eq 'la-pong'
      end
    end
  end
end
