class MatchesController < BaseController
  using_service MatchService

  def recent
    self.collection = service.find_recent
    respond_with collection
  end

  def create
    self.resource = service.new(safe_params)
    resource.save
    flash[:alert] = resource.errors.full_messages if resource.errors.any?
    respond_with resource, location: root_path
  end

  private

  def safe_params
    params.require(:match).permit(:winner, :loser)
  end
end
