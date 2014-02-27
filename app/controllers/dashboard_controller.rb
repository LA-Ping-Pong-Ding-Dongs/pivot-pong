class DashboardController < ApplicationController

  def show
    @match = MatchForm.new({})
  end

end