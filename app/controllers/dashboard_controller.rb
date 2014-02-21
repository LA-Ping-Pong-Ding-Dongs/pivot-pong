class DashboardController < ApplicationController

  def show
    @match = MatchForm.new
  end

  class MatchForm
    extend  ActiveModel::Naming
    include ActiveModel::Conversion

    def winner

    end

    def loser

    end
  end

end