class PlayersController < BaseController
  using_service PlayerService

  def show
    self.resource = finder
    respond_to do |format|
      format.json { render json: {results: resource} }
      format.html { respond_with collection }
    end
  end

  def finder
    service.find(params[:key])
  end

  def safe_params
    params.require(:player).permit(:name)
  end
end
