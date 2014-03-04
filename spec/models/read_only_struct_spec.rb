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

end