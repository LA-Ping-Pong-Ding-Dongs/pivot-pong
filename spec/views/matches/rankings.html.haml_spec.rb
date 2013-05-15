describe "matches/rankings.html.haml" do
  subject { rendered }

  let(:me) { Player.create(name: "me") }
  let(:you) { Player.create(name: "you") }

  before do
    assign :rankings, [me, you]
    render
  end

  it { should be }
  it { should include(me.to_s) }
  it { should include(you.to_s) }
end
