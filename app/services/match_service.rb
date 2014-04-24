module MatchService
  extend self, BaseService

  def decorator; MatchDecorator; end
  def collection_source; Match.all; end

  def new(attributes = nil)
    MatchFactory.new(attributes)
  end

  def find_recent
    decorate_collection(Match.find_recent)
  end
end
