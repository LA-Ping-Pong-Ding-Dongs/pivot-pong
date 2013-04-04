class DoublesMatchesController < ApplicationController
  def index
    @matches = Match.doubles_matches
  end
end

