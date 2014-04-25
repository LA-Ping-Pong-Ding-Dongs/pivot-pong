require 'spec_helper'

describe MatchesController do
  let :service do
    double(:match_service, find_recent: [])
  end

  before do
    allow(controller).to receive(:service).and_return(service)
  end

  describe '#recent' do
    context 'with js format' do
      it 'responds with collection json' do
        xhr :get, :recent
        expect(response).to be_success
        expect(response).to render_template('recent')
      end
    end

    context 'with html format'do
      it 'renders index' do
        get :recent
        expect(response).to be_success
        expect(response).to render_template('recent')
      end
    end
  end
end
