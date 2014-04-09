require 'spec_helper'

describe PlayerValidator do
  let(:valid_params) { { key: '55489db33455c06c6dc2d686e2c03433', name: 'Mallomar'} }
  let!(:created_player) { Player.create key: '55489db33455c06c6dc2d686e2c03433', name: 'Jamie' }

  it 'is invalid by default' do
    expect(PlayerValidator.new({})).to_not be_valid
  end

  it 'is valid' do
    expect(PlayerValidator.new(valid_params)).to be_valid
  end

  describe 'validity concerns' do
    let(:dup_name_player) { Player.create key: '93fb9466661fe0da4f07df6a745ffb81', name: 'Mallomar' }
    let(:updating_params) { { key: '6ce6380961f7b389e51a4080767f9aeb', name: 'Bella' } }

    it 'cannot be blank or nil' do
      expect(PlayerValidator.new(valid_params.merge({name: nil}))).to_not be_valid
      expect(PlayerValidator.new(valid_params.merge({name: ''}))).to_not be_valid
    end

    it 'has a unique update name' do
      dup_name_player
      expect(PlayerValidator.new(valid_params)).to_not be_valid
    end

    it 'checks for existing key in database' do
      expect(PlayerValidator.new(updating_params)).to_not be_valid
    end
  end
end