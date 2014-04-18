require 'spec_helper'

describe 'dashboard/show' do
  before do
    assign(:match, stub_model(Match, :winner => Object.new, :loser => Object.new))
    assign(:tournament_rankings, [])
    assign(:players, [])
  end
  it 'displays errors when present' do
    flash[:alert] = ['foo', 'bar']
    render
    expect(rendered).to match /foo/
    expect(rendered).to match /bar/
  end
end
