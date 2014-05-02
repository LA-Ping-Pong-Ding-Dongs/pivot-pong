require 'spec_helper'
require_relative '../../lib/tasks/blue_green_deploy_config'

describe BlueGreenDeployConfig do
  describe '#initialize' do
    subject { BlueGreenDeployConfig.new(cf_manifest, worker_app_names, target_color) }
    context 'given a parsed conforming manifest.yml' do
      let(:cf_manifest) { YAML.load_file('spec/tasks/manifest.yml') }
      let(:worker_app_names) { ['worker-bee', 'hard-worker'] }
      let(:target_color) { 'green' }

      it 'calculates the "Hot URL"' do
        expect(subject.hot_url).to eq 'la-pong'
      end

      it 'calculates the "target" worker app names' do
        expect(subject.target_worker_app_names[0]).to eq 'worker-bee-green'
        expect(subject.target_worker_app_names[1]).to eq 'hard-worker-green'
      end
    end
  end
end
