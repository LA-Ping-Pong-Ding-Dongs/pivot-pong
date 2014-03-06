class MatchesController < ApplicationController
  before_action :match_form, only: :create

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
      format.html { redirect_to root_path, alert: match_validator.errors }
    end
  end

  def index
    if params[:processed] == false
      render json: { results: match_finder.find_unprocessed.as_json }
    else
      render json: { results: match_finder.find_all.as_json }
    end
  end

  private

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