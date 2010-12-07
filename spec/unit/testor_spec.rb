require 'spec_helper'

describe "require 'testor'" do

  it 'should load the complete library' do
    lambda {
      require 'testor'
      Testor.should be_defined
    }.should_not raise_error(LoadError)
  end

end


