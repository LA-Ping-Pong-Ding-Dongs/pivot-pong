require 'spec_helper'

describe MatchesController do
  let :service do
    double(:match_service)
  end

  before do
    allow(controller).to receive(:service).and_return(service)
  end

  describe '#create' do
    let(:match_factory) { double('match factory', error_messages: 'didnt work yo', as_json: {fake: 'match'}) }
    let(:match_data) { { match: { winner: 'Foo', loser: 'Bar' } } }

    before do
      allow(service).to receive(:new).and_return(match_factory)
    end

    context 'responds to html' do
      describe 'success' do
        it 'does the same thing' do
          allow(match_factory).to receive(:save).and_return(true)
          post :create, match_data

          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to be_blank
        end
      end

      describe 'failure' do
        it 'adds an alert to the flash' do
          allow(match_factory).to receive(:save).and_return(false)
          post :create, match_data

          expect(response).to be_redirect
          expect(flash[:alert]).to be_present
        end
      end
    end

    context 'responds to json' do
      describe 'success' do
        it 'works' do
          allow(match_factory).to receive(:save).and_return(true)
          xhr :post, :create, match_data

          expect(response).to be_success
          expect(response.body).to eq('{"fake":"match"}')
        end
      end

      describe 'failure' do
        it 'includes an error key in the response' do
          allow(match_factory).to receive(:save).and_return(false)
          allow(match_factory).to receive(:errors).and_return(some: 'error')
          xhr :post, :create, match_data

          expect(response.status).to be(400)
          expect(response.body).to eq('{"fake":"match","some":"error"}')
        end
      end
    end
  end

  describe '#index' do
    before do
      allow(service).to receive(:get_page).and_return(double('matches collection'))
    end

    context 'responds with json' do
      it 'returns all matches' do
        xhr :get, :index
        expect(response).to be_success
      end
    end

    context 'responds with html' do
      it 'is successful' do
        get :index

        expect(response).to be_success
      end
    end

  end
end
