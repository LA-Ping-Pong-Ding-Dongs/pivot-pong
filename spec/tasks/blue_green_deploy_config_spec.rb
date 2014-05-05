require 'spec_helper'
require_relative '../../lib/tasks/blue_green_deploy_config'

describe BlueGreenDeployConfig do
  let(:cf_manifest) { YAML.load_file('spec/tasks/manifest.yml') }
  let(:web_app_name) { 'the-web-app' }
  let(:worker_app_names) { ['the-web-app-worker', 'hard-worker'] }
  let(:target_color) { nil }
  let(:deploy_config) { BlueGreenDeployConfig.new(cf_manifest, web_app_name, worker_app_names, target_color) }
  describe '#initialize' do
    subject { deploy_config }
    context 'given a parsed conforming manifest.yml' do
      it 'calculates the "Hot URL"' do
        expect(subject.hot_url).to eq 'the-web-url'
      end
    end
  end

  context 'the target color was provided' do
    let(:target_color) { 'green' }
    describe '.target_web_app_name' do
      subject { deploy_config.target_web_app_name }
      it 'calculates the "target" web app name' do
        expect(subject).to eq "the-web-app-#{target_color}"
      end
    end

    describe '.target_worker_app_names' do
      subject { deploy_config.target_worker_app_names }

      it 'calculates the "target" worker app names' do
        expect(subject[0]).to eq 'the-web-app-worker-green'
        expect(subject[1]).to eq 'hard-worker-green'
      end
    end
  end


  describe '#strip_color' do
    let(:app_name_with_color) { 'some-app-name-here-yay-blue' }
    subject { BlueGreenDeployConfig.strip_color(app_name_with_color) }

    it 'returns just the name of the app' do
      expect(subject).to eq 'some-app-name-here-yay'
    end

  end

  describe '#toggle_app_color' do
    let(:app_name) { 'app_name' }
    let(:target_app_name) { "#{app_name}-#{starting_color}" }
    subject { BlueGreenDeployConfig.toggle_app_color(target_app_name) }

    context 'where named app is the green instance' do
      let(:starting_color) { 'green' }
      it 'provides the blue app name' do
        expect(subject).to eq "#{app_name}-blue"
      end
    end
  end

  describe '.is_in_target?' do
    let(:target_color) { 'green' }
    let(:app_name) { "app_name-#{app_color}" }
    subject { deploy_config.is_in_target?(app_name) }

    context 'when the specified app IS the name of the target app' do
      let(:app_color) { target_color }
      it 'returns true' do
        expect(subject).to be true
      end
    end
    context 'when the specified app is NOT the name of the target app' do
      let(:app_color) { BlueGreenDeployConfig.toggle_color(target_color) }
      it 'returns false' do
        expect(subject).to be false
      end
    end
  end
end
