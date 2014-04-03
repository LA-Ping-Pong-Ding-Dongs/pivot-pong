class MatchesController < ApplicationController
  before_action :match_form, only: :create

  TOURNAMENT_MATCHES_LIMIT = 10

  def create
    respond_to do |format|
      if match_validator.valid?
        match_form.save
        format.js { render json: match_form.as_json }
      else
        format.js do
          errors = match_validator.errors.as_json
          render status: 400, json: match_form.as_json.merge(errors: errors)
        end
      end
      format.html { redirect_to root_path, alert: match_validator.errors.full_messages }
    end
  end

  def index
    if params[:recent]
      matches = match_finder.find_matches_for_tournament(tournament.start_time, tournament.end_time, TOURNAMENT_MATCHES_LIMIT)
    else
      matches = match_finder.find_all
    end

    @matches_presenter = matches.map { |match| MatchPresenter.new(match) }

    respond_to do |format|
      format.js { render json: { results: @matches_presenter.as_json } }
      format.html
    end
  end

  private

  def tournament
    @tournament ||= Tournament.new
  end

  def match_finder
    MatchFinder.new
  end

  def match_form
    @match_form ||= new_match_form
  end

  def match_validator
    @match_validator ||= new_match_validator
  end

  def new_match_form
    MatchForm.new(params.require(:match).permit(:winner, :loser))
  end

  def new_match_validator
    MatchValidator.new(params.require(:match).permit(:winner, :loser))
  end
end
