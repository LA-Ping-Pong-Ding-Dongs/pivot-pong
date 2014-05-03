require 'spec_helper'
require_relative '../../lib/tasks/blue_green_deploy_config'

describe BlueGreenDeployConfig do
  let(:cf_manifest) { YAML.load_file('spec/tasks/manifest.yml') }
  let(:worker_app_names) { ['worker-bee', 'hard-worker'] }
  let(:target_color) { 'green' }
  describe '#initialize' do
    subject { BlueGreenDeployConfig.new(cf_manifest, worker_app_names, target_color) }
    context 'given a parsed conforming manifest.yml' do

      it 'calculates the "Hot URL"' do
        expect(subject.hot_url).to eq 'la-pong'
      end

      it 'calculates the "target" worker app names' do
        expect(subject.target_worker_app_names[0]).to eq 'worker-bee-green'
        expect(subject.target_worker_app_names[1]).to eq 'hard-worker-green'
      end

      it 'calculates the "target" web app name' do
        expect(subject.target_web_app_name).to eq "pivot-pong-staging-#{target_color}"
      end
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
    let(:app_name) { "app_name-#{app_color}" }
    subject { BlueGreenDeployConfig.new(cf_manifest, worker_app_names, target_color).is_in_target?(app_name) }

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
