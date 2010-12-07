require 'spec_helper'

describe 'Testor::VERSION' do

  it 'should be defined' do
    lambda {
      require 'testor/version'
      Testor::VERSION.should be_defined
    }.should_not raise_error(LoadError)
  end

end

