require 'spec_helper'
require_relative '../../lib/tasks/blue_green_deploy'
require_relative 'cloud_foundry_fake'

describe BlueGreenDeploy do
  let(:cf_manifest) { YAML.load_file('spec/tasks/manifest.yml') }
  let(:deploy_config) { BlueGreenDeployConfig.new(cf_manifest) }
  let(:domain) { 'cfapps.io' }
  let(:hot_url) { 'la-pong' }
  let(:app_name) { 'app_name' }

  describe '#make_it_so' do
    context 'when blue/green is specified' do
      let(:worker_apps) { ['app_name-worker'] }
      let(:blue_or_green) { 'green' }
      let(:current_hot_app) { 'blue' }
      subject { BlueGreenDeploy.make_it_so(domain, app_name, worker_apps, deploy_config, blue_or_green) }
      before do
        allow(BlueGreenDeploy).to receive(:cf).and_return(CloudFoundryFake)
        CloudFoundryFake.init_route_table(domain, app_name, hot_url, current_hot_app)
      end

      it 'instructs Cloud Foundry to deploy the specified app' do
        expect(CloudFoundryFake).to receive(:push).with("#{app_name}-#{blue_or_green}")
        subject
      end

      it 'attempts to make that the hot app' do
        expect(BlueGreenDeploy).to receive(:make_hot).with(app_name, domain, deploy_config, blue_or_green)
        subject
      end
    end

    context 'when blue/green is omitted' do
      subject { BlueGreenDeploy.make_it_so(domain, app_name, worker_apps, deploy_config) }
      let(:worker_apps) { ['app_name-worker'] }
      before do
        allow(BlueGreenDeploy).to receive(:cf).and_return(CloudFoundryFake)
        CloudFoundryFake.init_route_table(domain, app_name, hot_url, current_hot_app)
      end

      context 'green is the current hot app' do
        let(:current_hot_app) { 'green' }

        it 'makes blue the current hot app' do
          subject
          expect(CloudFoundryFake.find_route(hot_url).app).to eq "#{app_name}-blue"
        end
      end

      context 'blue is the current hot app' do
        let(:current_hot_app) { 'blue' }

        it 'makes green the current hot app' do
          subject
          expect(CloudFoundryFake.find_route(hot_url).app).to eq "#{app_name}-green"
        end
      end

    end
  end

  describe '#ready_for_takeoff' do
    subject { BlueGreenDeploy.ready_for_takeoff(hot_app_name, hot_url, blue_or_green) }
    let(:blue_or_green) { 'green' }
    let(:hot_app_name) { "#{app_name}-#{current_hot_app}" }
    before do
      allow(BlueGreenDeploy).to receive(:cf).and_return(CloudFoundryFake)
      CloudFoundryFake.init_route_table(domain, app_name, hot_url, current_hot_app)
    end

    context 'the target color is opposite of what`s already hot' do
      let(:current_hot_app) { 'blue' }
      it 'does not raise an error: "It`s kosh!"' do
        expect{ subject }.to_not raise_error
      end

    end

    context 'the target color matches what`s already hot' do
      let(:current_hot_app) { 'green' }
      it 'raises an InvalidRouteStateError' do
        expect{ subject }.to raise_error(InvalidRouteStateError)
      end
    end

    context 'when blue/green is omitted' do
      let(:blue_or_green) { nil }

      context 'there is no current hot app' do
        let(:current_hot_app) { '' }
        let(:hot_app_name) { nil }
        before { CloudFoundryFake.remove_route(hot_url) }

        it 'raises an InvalidRouteStateError' do
          expect{ subject }.to raise_error(InvalidRouteStateError)
        end
      end
    end
  end

  describe '#get_hot_app' do
    subject { BlueGreenDeploy.get_hot_app(hot_url) }
    let(:current_hot_color) { 'green' }
    let(:hot_app) { "#{app_name}-#{current_hot_color}" }

    before do
      allow(BlueGreenDeploy).to receive(:cf).and_return(CloudFoundryFake)
      CloudFoundryFake.init_route_table(domain, app_name, hot_url, current_hot_color)
    end

    it 'returns the app mapped to that Host URL' do
      expect(subject).to eq hot_app
    end

    context 'when there is no app mapped to the hot url' do
      before do
        CloudFoundryFake.remove_route(hot_url)
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end


  describe '#make_hot' do
    let(:target_app) { 'blue' }
    let(:current_hot_app) { 'green' }
    subject { BlueGreenDeploy.make_hot(app_name, domain, deploy_config, target_app) }

    before do
      allow(BlueGreenDeploy).to receive(:cf).and_return(CloudFoundryFake)
      CloudFoundryFake.init_route_table(domain, app_name, hot_url, current_hot_app)
    end

    context 'when there is no current hot app' do
      before do
        CloudFoundryFake.remove_route(hot_url)
      end

      it 'the target_app is mapped to the hot_url' do
        subject
        expect(BlueGreenDeploy.get_hot_app(hot_url)).to eq "app_name-#{target_app}"
      end
    end

    context 'when there IS a hot URL route, but it is not mapped to any app' do
      before do
        CloudFoundryFake.remove_route(hot_url)
        CloudFoundryFake.add_route(Route.new(hot_url, domain, nil))
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
end
