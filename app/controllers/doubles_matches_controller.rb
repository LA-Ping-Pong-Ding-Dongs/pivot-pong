class DoublesMatchesController < ApplicationController
  def index
    @matches = Match.doubles_matches
    head :ok
  end
end

