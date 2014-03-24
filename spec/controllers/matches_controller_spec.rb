require 'spec_helper'

describe MatchesController do
  describe '#create' do
    let(:match_data) do
      {match: {winner: 'Bob', loser: 'Sally'}}
    end

    let(:errors) { ActiveModel::Errors.new('errors') }
    let(:match_validator) { instance_double(MatchValidator, valid?: true, errors: errors) }
    let(:match_form) { instance_double(MatchForm, save: true, as_json: match_data) }

    before do
      allow(controller).to receive(:new_match_form).and_return(match_form)
      allow(controller).to receive(:new_match_validator).and_return(match_validator)
    end

    context 'responds to html' do

      describe 'success' do
        it 'does the same thing' do
          post :create, match_data

          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to be_blank
          expect(assigns(:match_form)).to eq(match_form)
        end
      end

      describe 'failure' do
        let(:errors) { ActiveModel::Errors.new('errors').add(:bad_news, 'I failed') }
        let(:match_validator) { instance_double(MatchValidator, valid?: false, errors: errors) }
        let(:match_data) { {match: {invalid: "data"}} }

        it 'adds an alert to the flash' do
          post :create, match_data

          expect(response).to be_redirect
          expect(flash[:alert]).to be_present
          expect(assigns(:match_form)).to eq(match_form)
        end
      end
    end

    context 'responds to json' do

      describe 'success' do

        it 'works' do
          xhr :post, :create, match_data

          expect(response).to be_success
          expect(response.body).to eq(match_data.to_json)
        end
      end

      describe 'failure' do
        let(:errors) { ActiveModel::Errors.new('errors').add(:bad_news, 'I failed') }
        let(:match_validator) { instance_double(MatchValidator, valid?: false, errors: errors) }
        let(:match_data) { {match: {invalid: "data"}} }

        it 'includes an error key in the response' do
          xhr :post, :create, match_data

          expect(response.status).to be(400)
          expect(response.body).to eq(match_data.merge(errors: errors).to_json)
        end
      end
    end
  end

  describe '#index' do
    let(:match_1) { MatchStruct.new(1, 'Bob', 'Templeton', Time.now) }
    let(:match_2) { MatchStruct.new(2, 'Bob', 'Sally', Time.now) }
    let(:match_3) { MatchStruct.new(3, 'Sally', 'Templeton', Time.now) }
    let(:recent_matches) { [match_1, match_3] }
    let(:all_matches) { [match_1, match_2, match_3] }
    let(:match_finder_double) { double(MatchFinder, find_matches_for_tournament: recent_matches, find_all: all_matches) }

    before do
      expect(controller).to receive(:match_finder) { match_finder_double }
    end

    context 'responds with json' do
      it 'returns all matches' do
        xhr :get, :index

        expected = all_matches.map{ |match| MatchJsonPresenter.new(match).as_json }

        expect(response).to be_success
        expect(response.body).to eq({ 'results' => expected }.to_json)
      end

      it 'returns a list of recent matches' do
        xhr :get, :index, recent: 'true'

        expected = recent_matches.map{ |match| MatchJsonPresenter.new(match).as_json }

        expect(response).to be_success
        expect(response.body).to eq({ 'results' => expected }.to_json)
      end
    end

  end
end
