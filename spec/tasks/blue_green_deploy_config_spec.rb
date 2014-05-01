require 'spec_helper'
require_relative '../../lib/tasks/blue_green_deploy_config'

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
