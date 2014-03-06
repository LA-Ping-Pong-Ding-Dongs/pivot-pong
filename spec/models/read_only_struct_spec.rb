require 'spec_helper'

describe ReadOnlyStruct do
  subject { ReadOnlyStruct.new(field: 'value') }

  it 'should raise error when accessing field that has not been written to' do
    expect { subject.missing_field }.to raise_error(StandardError).with_message('missing_field')
  end

  it 'inherits from OpenStruct' do
    expect(subject).to be_kind_of OpenStruct
  end

  it 'returns a value for fields that do exist' do
    expect(subject.field).to eq 'value'
  end

  describe '#to_json' do
    it 'converts the struct to json' do
      expect(subject.to_json).to eq({ field: 'value' }.to_json)
    end
  end

  describe '#as_json' do
    it 'converts the struct to hash' do
      expect(subject.as_json).to eq({ field: 'value' }.to_h)
    end
  end

end
