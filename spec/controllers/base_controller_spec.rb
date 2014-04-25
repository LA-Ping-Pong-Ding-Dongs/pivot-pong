require 'spec_helper'

describe BaseController do
  class FakeModel
    def self.singular_route_key; 'base'; end
    def self.model_name; self; end
    def to_param; '1'; end
  end

  before do
    # adding routes to spec and abstract class
    # http://pivotallabs.com/adding-routes-for-tests-specs-with-rails-3/
    Rails.application.routes.draw do
      root 'base#index'
      resources :base
    end

    # empty views to the abstract controller can be tested
    controller.prepend_view_path 'spec/fixtures/views'
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
    allow(controller).to receive(:service).and_return(service)
    allow(controller).to receive(:safe_params).and_return({})
  end

  describe '#update' do
    let(:model) { FakeModel.new }
    context 'js response' do
      before do
        allow(service).to receive(:find).and_return(model)
      end

      it 'redirects to model show page on success' do
        allow(model).to receive(:update_attributes).and_return(true)
        allow(model.class).to receive(:model_name).and_return(FakeModel)
        patch :update, id: 1, model: { name: 'Mallomar' }
        expect(response).to redirect_to('http://test.host/base/1')
      end

      it 'renders edit with errors if save fails' do
        allow(model).to receive(:update_attributes).and_return(false)
        allow(model).to receive(:errors).and_return([1])
        patch :update, id: 1, model: { name: 'Templeton' }
        expect(response).to render_template('edit')
      end
    end
  end


  describe '#create' do
    let(:model) { FakeModel.new }

    before do
      allow(service).to receive(:new).and_return(model)
    end

    context 'responds to html' do
      describe 'success' do
        it 'does the same thing' do
          allow(model).to receive(:save).and_return(true)
          post :create, params

          expect(response).to redirect_to('/base/1')
          expect(flash[:alert]).to be_blank
        end
      end

      describe 'failure' do
        it 'adds an alert to the flash' do
          allow(model).to receive(:save).and_return(false)
          post :create, params

          expect(response).to be_redirect
        end
      end
    end

    context 'responds to json' do
      describe 'success' do
        it 'works' do
          allow(model).to receive(:save).and_return(true)
          allow(model).to receive(:as_json).and_return(fake: 'persistence object')
          xhr :post, :create, params.merge(format: :json)

          expect(response).to be_success
          expect(response.body).to eq('{"fake":"persistence object"}')
        end
      end

      describe 'failure' do
        it 'includes an error key in the response' do
          allow(model).to receive(:save).and_return(false)
          allow(model).to receive(:errors).and_return(some: 'error')
          xhr :post, :create, params.merge(format: :json)

          expect(response.status).to be(422)
          expect(response.body).to eq('{"errors":{"some":"error"}}')
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
