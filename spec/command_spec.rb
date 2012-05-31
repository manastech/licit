require 'spec_helper'
require 'licit'

describe Licit::Command do

  it "load config file" do
    Dir.chdir(File.expand_path '../dir3', __FILE__) do
      subject.load_config.should == {copyright: 'Copyright Line', program_name: 'My App'}
    end
  end

end