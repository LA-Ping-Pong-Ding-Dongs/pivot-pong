require 'spec_helper'

describe BaseController do
  # adding routes to spec and abstract class
  # http://pivotallabs.com/adding-routes-for-tests-specs-with-rails-3/
  render_views false
  before do
    Rails.application.routes.draw do
      root 'base#index'
      resources :base
    end
  end

  after do
    Rails.application.reload_routes!
  end


  let :service do
    double(:service)
  end

  let(:params) do
    { some: 'params' }
  end

  before do
    controller.class.using_service(service)
    allow(controller).to receive(:safe_params).and_return({})
  end

  describe '#create' do
    let(:factory) { double('factory', error_messages: 'didnt work yo', as_json: {fake: 'persistence object'}) }

    before do
      allow(service).to receive(:new).and_return(factory)
    end

    context 'responds to html' do
      describe 'success' do
        it 'does the same thing' do
          allow(factory).to receive(:save).and_return(true)
          post :create, params

          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to be_blank
        end
      end

      describe 'failure' do
        it 'adds an alert to the flash' do
          allow(factory).to receive(:save).and_return(false)
          post :create, params

          expect(response).to be_redirect
          expect(flash[:alert]).to be_present
        end
      end
    end

    context 'responds to json' do
      describe 'success' do
        it 'works' do
          allow(factory).to receive(:save).and_return(true)
          xhr :post, :create, params.merge(format: :json)

          expect(response).to be_success
          expect(response.body).to eq('{"fake":"persistence object"}')
        end
      end

      describe 'failure' do
        it 'includes an error key in the response' do
          allow(factory).to receive(:save).and_return(false)
          allow(factory).to receive(:errors).and_return(some: 'error')
          xhr :post, :create, params.merge(format: :json)

          expect(response.status).to be(400)
          expect(response.body).to eq('{"fake":"persistence object","some":"error"}')
        end
      end
    end
  end

  describe '#index' do
    before do
      allow(service).to receive(:get_page).and_return(double('paginated collection'))
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
