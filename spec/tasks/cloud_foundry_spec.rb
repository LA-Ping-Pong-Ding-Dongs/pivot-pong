require 'spec_helper'
require_relative '../../lib/tasks/cloud_foundry'

describe CloudFoundry do
  describe '#push' do
    subject { CloudFoundry.push(app) }
    let(:app) { 'app_name-blue' }

    it 'invokes the CloudFoundry CLI command "push"' do
      expect(CommandLine).to receive(:system).with("cf push #{app}")
      subject
    end
  end

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
