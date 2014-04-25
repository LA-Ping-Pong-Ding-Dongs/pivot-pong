class PlayersController < BaseController
  using_service PlayerService

  def show
    self.resource = finder
    respond_with resource
  end

  def finder
    service.find(params[:key])
  end

  def safe_params
    params.require(:player).permit(:name)
  end
end
