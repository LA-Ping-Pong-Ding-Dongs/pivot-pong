require 'spec_helper'

describe MatchesController do
  let :service do
    double(:match_service, find_recent: [])
  end

  before do
    controller.class.using_service(service)
  end

  describe '#recent' do
    context 'with js format' do
      it 'responds with collection json' do
        xhr :get, :recent
        expect(response).to be_success
        expect(response.body).to eql('{"results":[]}')
      end
    end

    context 'with html format'do
      it 'renders index' do
        get :recent
        expect(response).to be_success
        expect(response).to render_template('index')
      end
    end
  end
end
