class MatchesController < BaseController
  using_service MatchService

  def recent
    self.collection = service.find_recent
    respond_to do |format|
      format.js { render json: { results: collection.as_json } }
      format.html { render action: :index }
    end
  end

  private

  def safe_params
    params.require(:match).permit(:winner, :loser)
  end
end
