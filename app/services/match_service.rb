module MatchService
  extend self

  delegate :all, :find_recent, to: Match
  delegate :new, to: MatchFactory
end
